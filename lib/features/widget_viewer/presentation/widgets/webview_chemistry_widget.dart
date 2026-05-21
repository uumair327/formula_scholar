import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewChemistryWidget extends StatefulWidget {
  const WebviewChemistryWidget({
    super.key,
    required this.config,
  });

  final Map<String, dynamic> config;

  @override
  State<WebviewChemistryWidget> createState() => _WebviewChemistryWidgetState();
}

class _WebviewChemistryWidgetState extends State<WebviewChemistryWidget> {
  late final WebViewController _controller;
  bool _pageLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
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

  @override
  void didUpdateWidget(covariant WebviewChemistryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config && _pageLoaded) {
      _triggerRender();
    }
  }

  void _triggerRender() {
    final smiles = widget.config['smiles'] as String? ?? 'CCO'; // Default Ethanol
    final renderMode = widget.config['renderMode'] as String? ?? '2d'; // '2d' or '3d'
    
    _controller.runJavaScript(
      "if (window.renderMolecule) { window.renderMolecule('$renderMode', '$smiles'); }"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: WebViewWidget(controller: _controller),
    );
  }

  String _buildHtmlString() {
    return """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    body, html {
      margin: 0; padding: 0; width: 100%; height: 100%;
      background-color: #121212; overflow: hidden;
      display: flex; justify-content: center; align-items: center;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      color: #ffffff;
    }
    #container { width: 100%; height: 100%; display: flex; justify-content: center; align-items: center; }
    canvas { max-width: 95%; max-height: 95%; }
    .mol-container {
      width: 100%; height: 100%;
      position: relative;
    }
  </style>
  <script src="https://unpkg.com/smiles-drawer@2.0.1/dist/smiles-drawer.min.js"></script>
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
          let viewer = \$3Dmol.createViewer(\$(div), { backgroundColor: '#121212' });
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
            
            // Subtle rotation animation
            let angle = 0;
            setInterval(() => {
              if (viewer) {
                viewer.rotate(0.5, 'y');
                viewer.render();
              }
            }, 30);
          }).fail(function() {
            // Mock SDF for offline fallback (Water Molecule)
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
        container.appendChild(canvas);

        setTimeout(() => {
          try {
            let smilesDrawer = new SmilesDrawer.Drawer({
              width: window.innerWidth * 0.9,
              height: window.innerHeight * 0.9,
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
  </script>
</body>
</html>
""";
  }
}
