import 'dart:math' as math;

/// Recursive-descent parser for mathematical expressions.
///
/// Grammar:
/// Utility class to evaluate math expressions from LaTeX/text formula format.
class GraphExpressionEvaluator {
  /// Evaluates an expression at a given x with named parameters.
  static double? evaluate(String latex, double x, Map<String, double> params) {
    try {
      // Clean the LaTeX to a math-evaluable string
      var expr = latex.toLowerCase().replaceAll(' ', '');
      // Remove 'y=' prefix
      if (expr.startsWith('y=')) {
        expr = expr.substring(2);
      }

      // Replace known LaTeX commands with operator equivalents
      expr = expr
          .replaceAll('\\\\cdot', '*')
          .replaceAll('\\cdot', '*')
          .replaceAll('**', '^');

      return evalExpr(expr, x, params);
    } catch (_) {
      return null;
    }
  }

  /// Evaluates a raw expression string.
  static double? evalExpr(String raw, double x, Map<String, double> params) {
    final tokens = tokenize(raw);
    if (tokens.isEmpty) return null;
    final parser = ExprParser(tokens, x, params);
    final result = parser.parseExpression();
    return result;
  }

  /// Tokenizes a raw mathematical expression string.
  static List<String> tokenize(String expr) {
    final tokens = <String>[];
    var i = 0;
    while (i < expr.length) {
      final ch = expr[i];
      if (ch == ' ') {
        i++;
        continue;
      }
      // Numbers (with optional decimal)
      if (_isDigit(ch) ||
          (ch == '.' && i + 1 < expr.length && _isDigit(expr[i + 1]))) {
        final sb = StringBuffer();
        while (i < expr.length && (_isDigit(expr[i]) || expr[i] == '.')) {
          sb.write(expr[i]);
          i++;
        }
        tokens.add(sb.toString());
        continue;
      }
      // Operators and parens
      if ('+-*/^()'.contains(ch)) {
        tokens.add(ch);
        i++;
        continue;
      }
      // Identifiers / functions
      if (_isAlpha(ch)) {
        final sb = StringBuffer();
        while (i < expr.length &&
            (_isAlpha(expr[i]) || _isDigit(expr[i]) || expr[i] == '_')) {
          sb.write(expr[i]);
          i++;
        }
        tokens.add(sb.toString());
        continue;
      }
      i++; // skip unknown chars
    }
    return tokens;
  }

  static bool _isDigit(String ch) =>
      ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;
  static bool _isAlpha(String ch) {
    final c = ch.codeUnitAt(0);
    return (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
  }
}

/// Recursive-descent parser for mathematical expressions.
///
/// Grammar:
///   expression = term (('+' | '-') term)*
///   term       = unary (('*' | '/') unary)*
///   unary      = ('-')? power
///   power      = atom ('^' unary)?
///   atom       = NUMBER | IDENT | IDENT '(' expression ')' | '(' expression ')'
class ExprParser {
  ExprParser(this._tokens, this._x, this._params);

  final List<String> _tokens;
  final double _x;
  final Map<String, double> _params;
  int _pos = 0;

  String? _peek() => _pos < _tokens.length ? _tokens[_pos] : null;
  String _advance() => _tokens[_pos++];
  bool _match(String expected) {
    if (_peek() == expected) {
      _pos++;
      return true;
    }
    return false;
  }

  double parseExpression() {
    var result = _parseTerm();
    while (true) {
      if (_match('+')) {
        result += _parseTerm();
      } else if (_match('-')) {
        result -= _parseTerm();
      } else {
        break;
      }
    }
    return result;
  }

  double _parseTerm() {
    var result = _parseUnary();
    while (true) {
      if (_match('*')) {
        result *= _parseUnary();
      } else if (_match('/')) {
        final divisor = _parseUnary();
        if (divisor == 0) return double.nan;
        result /= divisor;
      } else {
        // Implicit multiplication: number followed by identifier or '('
        final next = _peek();
        if (next != null &&
            next != '+' &&
            next != '-' &&
            next != '*' &&
            next != '/' &&
            next != '^' &&
            next != ')' &&
            !_isNumeric(next)) {
          result *= _parseUnary();
        } else {
          break;
        }
      }
    }
    return result;
  }

  double _parseUnary() {
    if (_match('-')) {
      return -_parsePower();
    }
    return _parsePower();
  }

  double _parsePower() {
    final base = _parseAtom();
    if (_match('^')) {
      final exp = _parseUnary(); // right-associative
      return math.pow(base, exp).toDouble();
    }
    return base;
  }

  double _parseAtom() {
    final token = _peek();
    if (token == null) return 0;

    // Parenthesized expression
    if (token == '(') {
      _advance();
      final result = parseExpression();
      _match(')'); // consume closing paren
      return result;
    }

    // Number literal
    if (_isNumeric(token)) {
      _advance();
      return double.tryParse(token) ?? 0;
    }

    // Identifier: variable, constant, or function
    _advance();
    final name = token;

    // Function call: name followed by '('
    if (_peek() == '(') {
      _advance(); // consume '('
      final arg = parseExpression();
      _match(')'); // consume ')'
      return _callFunction(name, arg);
    }

    // Known constants and variables
    return _resolveVariable(name);
  }

  double _callFunction(String name, double arg) {
    switch (name) {
      case 'sin':
        return math.sin(arg);
      case 'cos':
        return math.cos(arg);
      case 'tan':
        return math.tan(arg);
      case 'sqrt':
        return arg >= 0 ? math.sqrt(arg) : double.nan;
      case 'abs':
        return arg.abs();
      case 'log':
      case 'ln':
        return arg > 0 ? math.log(arg) : double.nan;
      case 'exp':
        return math.exp(arg);
      case 'asin':
        return math.asin(arg);
      case 'acos':
        return math.acos(arg);
      case 'atan':
        return math.atan(arg);
      default:
        return arg; // unknown function — treat as identity
    }
  }

  double _resolveVariable(String name) {
    if (name == 'x') return _x;
    if (name == 'pi') return math.pi;
    if (name == 'e') return math.e;
    // Look up parameter by exact name, then case-insensitive
    if (_params.containsKey(name)) return _params[name]!;
    final upper = name.toUpperCase();
    for (final entry in _params.entries) {
      if (entry.key.toUpperCase() == upper) return entry.value;
    }
    return 0;
  }

  bool _isNumeric(String s) {
    if (s.isEmpty) return false;
    final c = s.codeUnitAt(0);
    return (c >= 48 && c <= 57) || s[0] == '.';
  }
}
