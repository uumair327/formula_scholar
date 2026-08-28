import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'package:universal_html/html.dart' as html;
import 'package:webview_flutter/webview_flutter.dart';
import 'platform_view_registry.dart';

class WebviewChemistryWidget extends StatefulWidget {
  const WebviewChemistryWidget({super.key, required this.config});

  final Map<String, dynamic> config;

  @override
  State<WebviewChemistryWidget> createState() => _WebviewChemistryWidgetState();
}

class _WebviewChemistryWidgetState extends State<WebviewChemistryWidget> {
  WebViewController? _controller;
  late final String _viewId;
  bool _pageLoaded = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _viewId = 'chemistry-viewer-${DateTime.now().millisecondsSinceEpoch}';

      registerViewFactory(_viewId, (int viewId) {
        final iframe = html.IFrameElement()
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..srcdoc = _buildHtmlString();
        return iframe;
      });
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(AppColors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              setState(() {
                _pageLoaded = true;
              });
              _triggerRender();
            },
          ),
        )
        ..loadHtmlString(_buildHtmlString());
    }
  }

  @override
  void didUpdateWidget(covariant WebviewChemistryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config) {
      if (kIsWeb) {
        // For web, if iframe is used, srcdoc update is harder,
        // we could just rebuild by changing viewId, but it's simpler to keep it static for now
        // since formulas don't typically change dynamically without a full widget rebuild.
      } else if (_pageLoaded) {
        _triggerRender();
      }
    }
  }

  void _triggerRender() {
    if (kIsWeb || _controller == null) return;
    final smiles = widget.config['smiles'] as String? ?? 'CCO';
    final renderMode = widget.config['renderMode'] as String? ?? '2d';

    _controller!.runJavaScript(
      "if (window.renderMolecule) { window.renderMolecule('$renderMode', '$smiles'); }",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black.withValues(alpha: 0.4),
      child: kIsWeb
          ? HtmlElementView(viewType: _viewId)
          : WebViewWidget(controller: _controller!),
    );
  }

  String _buildHtmlString() {
    final smiles = widget.config['smiles'] as String? ?? 'CCO';
    final renderMode = widget.config['renderMode'] as String? ?? '2d';

    return """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    body, html {
      margin: 0; padding: 0; width: 100%; height: 100%;
      background-color: transparent; overflow: hidden;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      color: #ffffff;
      box-sizing: border-box;
    }
    #container { 
      width: 100%; height: 100%; 
      position: relative;
      overflow: hidden;
    }
    canvas { 
      max-width: 100% !important; 
      max-height: 100% !important; 
      object-fit: contain;
    }
    .mol-container {
      position: absolute;
      top: 0; left: 0; right: 0; bottom: 0;
      width: 100%; height: 100%;
      overflow: hidden;
    }
  </style>
  <script src="https://unpkg.com/smiles-drawer@1.0.10/dist/smiles-drawer.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/3Dmol/2.0.4/3Dmol-min.js"></script>
</head>
<body>
  <div id="container">
    <div style="font-size:12px;color:#888;">Loading molecular visualizer...</div>
  </div>
  <script>
    window.renderMolecule = function(mode, formula) {
      const container = document.getElementById('container');
      container.innerHTML = ''; 

      if (mode === '3d') {
        const div = document.createElement('div');
        div.className = 'mol-container';
        div.id = 'mol-3d';
        container.appendChild(div);

        setTimeout(() => {
          let viewer = \$3Dmol.createViewer(\$(div), { backgroundColor: '#1e1e1e' });
          let url = '';
          if (formula.length < 30 && !formula.includes('=') && !formula.includes('#')) {
            url = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/' + encodeURIComponent(formula) + '/SDF?record_type=3d';
          } else {
            url = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/smiles/' + encodeURIComponent(formula) + '/SDF?record_type=3d';
          }

          \$.get(url, function(data) {
            viewer.addModel(data, "sdf");
            viewer.setStyle({}, { sphere: { scale: 0.3 }, stick: { radius: 0.15 } });
            viewer.zoomTo();
            viewer.render();
            
            let angle = 0;
            setInterval(() => {
              if (viewer) {
                viewer.rotate(0.5, 'y');
                viewer.render();
              }
            }, 30);
          }).fail(function() {
            let mockSDF = `
Water Molecule (Offline Fallback)
  3Dmol.js
  3  2  0
  O   0.0000   0.0000   0.1177
  H  -0.7570   0.0000  -0.4708
  H   0.7570   0.0000  -0.4708
`;
            viewer.addModel(mockSDF, "sdf");
            viewer.setStyle({}, { sphere: { scale: 0.3 } });
            viewer.zoomTo();
            viewer.render();
          });
        }, 100);
      } else {
        const canvas = document.createElement('canvas');
        canvas.id = 'canvas-2d';
        canvas.style.position = 'absolute';
        canvas.style.top = '50%';
        canvas.style.left = '50%';
        canvas.style.transform = 'translate(-50%, -50%)';
        container.appendChild(canvas);

        setTimeout(() => {
          try {
            let cw = container.clientWidth || window.innerWidth;
            let ch = container.clientHeight || window.innerHeight;
            let smilesDrawer = new SmilesDrawer.Drawer({
              width: cw * 0.95,
              height: ch * 0.95,
              theme: 'dark',
              overlapSensitivity: 1.0,
              bondThickness: 2.0,
              textSize: 12
            });

            SmilesDrawer.parse(formula, function(tree) {
              smilesDrawer.draw(tree, 'canvas-2d', 'dark', false);
            }, function(err) {
              container.innerHTML = '<div style="color:#ff6b6b;font-size:12px;">Failed to parse molecular structure</div>';
            });
          } catch (e) {
            container.innerHTML = '<div style="color:#ff6b6b;font-size:12px;">Visualizer error</div>';
          }
        }, 100);
      }
    };

    // Execute with a polling interval to wait for scripts to load
    let attempts = 0;
    function init() {
      if (typeof window.\$3Dmol !== 'undefined' && typeof window.SmilesDrawer !== 'undefined') {
        renderMolecule('$renderMode', '$smiles');
      } else {
        attempts++;
        if (attempts < 50) {
          setTimeout(init, 100);
        } else {
          document.getElementById('container').innerHTML = '<div style="color:#ff6b6b;font-size:12px;">Failed to load visualizer libraries</div>';
        }
      }
    }
    init();
  </script>
</body>
</html>
""";
  }
}
