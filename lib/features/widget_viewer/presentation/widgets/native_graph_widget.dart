import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class NativeGraphWidget extends StatefulWidget {
  const NativeGraphWidget({
    super.key,
    required this.config,
    required this.parameters,
  });

  final Map<String, dynamic> config;
  final Map<String, double> parameters;

  @override
  State<NativeGraphWidget> createState() => _NativeGraphWidgetState();
}

class _InteractiveGraphState {
  double panX = 0;
  double panY = 0;
  double scale = 1.0;
}

class _NativeGraphWidgetState extends State<NativeGraphWidget> {
  final _InteractiveGraphState _viewState = _InteractiveGraphState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final expressions = widget.config['expressions'] as List<dynamic>? ?? [];
    final viewport = widget.config['viewport'] as Map<String, dynamic>? ?? {};

    final double xMinDefault = (viewport['xMin'] ?? -10.0) as double;
    final double xMaxDefault = (viewport['xMax'] ?? 10.0) as double;
    final double yMinDefault = (viewport['yMin'] ?? -10.0) as double;
    final double yMaxDefault = (viewport['yMax'] ?? 10.0) as double;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Adjust pan based on screen movement
          _viewState.panX += details.delta.dx;
          _viewState.panY += details.delta.dy;
        });
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.2),
        child: ClipRect(
          child: CustomPaint(
            painter: _GraphPainter(
              expressions: expressions,
              parameters: widget.parameters,
              xMinDefault: xMinDefault,
              xMaxDefault: xMaxDefault,
              yMinDefault: yMinDefault,
              yMaxDefault: yMaxDefault,
              panX: _viewState.panX,
              panY: _viewState.panY,
              colorScheme: colorScheme,
            ),
          ),
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  _GraphPainter({
    required this.expressions,
    required this.parameters,
    required this.xMinDefault,
    required this.xMaxDefault,
    required this.yMinDefault,
    required this.yMaxDefault,
    required this.panX,
    required this.panY,
    required this.colorScheme,
  });

  final List<dynamic> expressions;
  final Map<String, double> parameters;
  final double xMinDefault;
  final double xMaxDefault;
  final double yMinDefault;
  final double yMaxDefault;
  final double panX;
  final double panY;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    // Current coordinate limits including pan
    final widthVal = xMaxDefault - xMinDefault;
    final heightVal = yMaxDefault - yMinDefault;

    final double scaleX = size.width / widthVal;
    final double scaleY = size.height / heightVal;

    final double shiftX = panX / scaleX;
    final double shiftY = panY / scaleY;

    final xMin = xMinDefault - shiftX;
    final xMax = xMaxDefault - shiftX;
    final yMin = yMinDefault + shiftY;
    final yMax = yMaxDefault + shiftY;

    // Projection helpers
    Offset toScreen(double x, double y) {
      final sx = ((x - xMin) / (xMax - xMin)) * size.width;
      final sy = size.height - (((y - yMin) / (yMax - yMin)) * size.height);
      return Offset(sx, sy);
    }

    // Grid Painter
    final gridPaint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = colorScheme.onSurface.withValues(alpha: 0.4)
      ..strokeWidth = 2.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw vertical grid lines
    final stepX = _calculateStep(xMax - xMin);
    final double startX = (xMin / stepX).floor() * stepX;
    for (double x = startX; x <= xMax; x += stepX) {
      final p1 = toScreen(x, yMin);
      final p2 = toScreen(x, yMax);
      canvas.drawLine(p1, p2, gridPaint);

      // Label
      if (x != 0 && p1.dx > 10 && p1.dx < size.width - 10) {
        final origin = toScreen(x, 0);
        final labelY = origin.dy.clamp(10.0, size.height - 20.0);
        textPainter.text = TextSpan(
          text: x.toStringAsFixed(x.abs() < 1 ? 1 : 0),
          style: TextStyle(color: colorScheme.outline, fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(p1.dx - textPainter.width / 2, labelY + 2));
      }
    }

    // Draw horizontal grid lines
    final stepY = _calculateStep(yMax - yMin);
    final double startY = (yMin / stepY).floor() * stepY;
    for (double y = startY; y <= yMax; y += stepY) {
      final p1 = toScreen(xMin, y);
      final p2 = toScreen(xMax, y);
      canvas.drawLine(p1, p2, gridPaint);

      // Label
      if (y != 0 && p1.dy > 10 && p1.dy < size.height - 20) {
        final origin = toScreen(0, y);
        final labelX = origin.dx.clamp(5.0, size.width - 25.0);
        textPainter.text = TextSpan(
          text: y.toStringAsFixed(y.abs() < 1 ? 1 : 0),
          style: TextStyle(color: colorScheme.outline, fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(labelX + 4, p1.dy - textPainter.height / 2));
      }
    }

    // Draw axes
    final origin = toScreen(0, 0);
    // Y-Axis
    if (origin.dx >= 0 && origin.dx <= size.width) {
      canvas.drawLine(Offset(origin.dx, 0), Offset(origin.dx, size.height), axisPaint);
    }
    // X-Axis
    if (origin.dy >= 0 && origin.dy <= size.height) {
      canvas.drawLine(Offset(0, origin.dy), Offset(size.width, origin.dy), axisPaint);
    }

    // Plot Expressions
    for (final expr in expressions) {
      if (expr is! Map<String, dynamic>) continue;
      final colorHex = expr['color'] as String? ?? '#3B82F6';
      final latex = expr['latex'] as String? ?? '';
      
      final graphPaint = Paint()
        ..color = _parseColor(colorHex)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      final path = Path();
      bool first = true;
      const pointCount = 200;

      for (int i = 0; i <= pointCount; i++) {
        final double t = i / pointCount;
        final double x = xMin + t * (xMax - xMin);
        final double? y = _evaluate(latex, x, parameters);

        if (y != null && !y.isNaN && !y.isInfinite) {
          final pt = toScreen(x, y);
          if (pt.dy >= -100 && pt.dy <= size.height + 100) {
            if (first) {
              path.moveTo(pt.dx, pt.dy);
              first = false;
            } else {
              path.lineTo(pt.dx, pt.dy);
            }
          } else {
            first = true; // Break continuity
          }
        } else {
          first = true;
        }
      }
      canvas.drawPath(path, graphPaint);
      
      // Draw Roots / Special Features (if highlighted)
      _drawRoots(canvas, latex, parameters, toScreen, colorScheme);
    }
  }

  double _calculateStep(double range) {
    if (range < 5) return 0.5;
    if (range < 25) return 2.0;
    if (range < 100) return 10.0;
    return 50.0;
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return Colors.blue;
    }
  }

  double? _evaluate(String latex, double x, Map<String, double> params) {
    return GraphExpressionEvaluator.evaluate(latex, x, params);
  }

  void _drawRoots(
    Canvas canvas,
    String latex,
    Map<String, double> params,
    Offset Function(double, double) toScreen,
    ColorScheme colorScheme,
  ) {
    final lower = latex.toLowerCase().replaceAll(' ', '');
    if (lower.contains('x^2') && !lower.contains('sin') && !lower.contains('cos')) {
      // Draw roots for quadratic y = ax^2 + bx + c
      final double a = params['a'] ?? 1.0;
      final double b = params['b'] ?? 0.0;
      final double c = params['c'] ?? 0.0;

      final discriminant = b * b - 4 * a * c;
      if (discriminant >= 0) {
        final r1 = (-b + math.sqrt(discriminant)) / (2 * a);
        final r2 = (-b - math.sqrt(discriminant)) / (2 * a);

        final rootPaint = Paint()
          ..color = AppColors.secondary
          ..style = PaintingStyle.fill;

        final glowPaint = Paint()
          ..color = AppColors.secondary.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

        void drawRootPoint(double rx) {
          final pt = toScreen(rx, 0);
          canvas.drawCircle(pt, 8.0, glowPaint);
          canvas.drawCircle(pt, 4.0, rootPaint);
        }

        drawRootPoint(r1);
        if (r1 != r2) {
          drawRootPoint(r2);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) {
    return oldDelegate.panX != panX ||
        oldDelegate.panY != panY ||
        oldDelegate.parameters != parameters ||
        oldDelegate.expressions != expressions;
  }
}

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
      if (_isDigit(ch) || (ch == '.' && i + 1 < expr.length && _isDigit(expr[i + 1]))) {
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
        while (i < expr.length && (_isAlpha(expr[i]) || _isDigit(expr[i]) || expr[i] == '_')) {
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

  static bool _isDigit(String ch) => ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;
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
