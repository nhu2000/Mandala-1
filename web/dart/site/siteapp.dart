part of SiteLib;

class SiteApp {
  TopMenuController _topMenu;
  DrawingTool _drawingModule;

  SiteApp( this._drawingModule ) {
    // Check if on the site
    _topMenu = new TopMenuController();

    _setupToolbar();
  }

  void _setupToolbar(){
    querySelector("#nu-interface-save-svg").onClick.listen( _onSvgSave );
    querySelector("#nu-interface-save-image").onClick.listen( _onSaveImage );
    querySelector("#nu-interface-publish").onClick.listen( _onPublishRequested );
  }


  /// Save out an SVG version of the mandala
  void _onSvgSave(e) {
    // Create the SVG
    Svg.SvgElement svg = _drawingModule.saveSvg();

    // Convert to blob
    var blob = new Blob([svg.outerHtml], "image/svg+xml");
//
//    // Open preview window with download link
//    var previewWindow = window.open("", "");
//    var a = new AnchorElement(href: Url.createObjectUrlFromBlob( blob ) );
//    a.text = "Download";
//    a.style.display = "block";
//    a.download = "mandala.svg";
//    a.onClick.listen((e) { // clenaup
//      new Future.delayed(new Duration(seconds:2), () => Url.revokeObjectUrl(a.href));
//    });
//
//    // Add the <a> tag, followed by the SVG
//    previewWindow.document.body.nodes.add(a);
//    previewWindow.document.body.nodes.add(svg);

    // Open window with just SVG data as XML
    window.open(Url.createObjectUrlFromBlob( blob ), "svg-text");
  }

  /// Saves out an image representation of the mandala
  void _onSaveImage(e) {
    print("ImageSave");
    ImageElement img = new ImageElement();
    img.src = _drawingModule.getDataUrl();

    var newWindow = window.open("", "");
    newWindow.document.body.nodes.add(img);
  }

  void _onPublishRequested(e) {
    String imageData = _drawingModule.getDataUrl();
    HttpRequest.postFormData("/mandalas/create_from_tool", {
      "image_data": imageData,
      "id"       : _drawingModule.mandalaId == null ? "" : _drawingModule.mandalaId
    });
  }
}