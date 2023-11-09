function resizeable() {
  var fileName = location.href.split("/").slice(-1);
  if (isNaN(fileName[0])) {
    fileName = fileName[0];
  }
  else {
    fileName = location.href.split("/").slice(-2)[0];
  }
  var p = document.querySelector('#quick-edit');
  var wrapper = document.querySelector('#quick-edit-body-wrapper');
  var resizer = document.createElement('div');
  var resizerIcon = document.createElement('div');
  if (p !== null) {
    resizer.className = 'resizer';
    resizerIcon.className = 'resizer-icon';
    p.appendChild(resizer);
    p.appendChild(resizerIcon);
    resizerIcon.addEventListener('mousedown', initDrag, false);
    resizer.addEventListener('mousedown', initDrag, false);
    resizerIcon.addEventListener('touchstart', initDragMobile, false);
    resizer.addEventListener('touchstart', initDragMobile, false);
    var height = Cookie.getCookie('height' + fileName);
    if (height.length > 0) {
      QuickEdit.HEIGHT_MULTIPLIER = 0.9;
      wrapper.style.setProperty('height', height + 'px', 'important');
      wrapper.style.setProperty('max-height', height + 'px', 'important');
      p.style.height = height + 'px';
    }
  }

  var startX, startY, startWidth, startHeight;

  function initDrag(e) {
    startX = e.clientX;
    startY = e.clientY;
    startWidth = parseInt(document.defaultView.getComputedStyle(p).width, 10);
    startHeight = parseInt(document.defaultView.getComputedStyle(p).height, 10);
    document.documentElement.addEventListener('mousemove', doDrag, false);
    document.documentElement.addEventListener('mouseup', stopDrag, false);
  }

  function doDrag(e) {
    var heightValue = (startHeight - e.clientY + startY);
    wrapper.style.setProperty('height', heightValue + 'px', 'important');
    wrapper.style.setProperty('max-height', heightValue + 'px', 'important');
    p.style.height = heightValue + 'px';
    Cookie.createCookie('height' + fileName, heightValue, 99);
  }

  function stopDrag(e) {
    document.documentElement.removeEventListener('mousemove', doDrag, false);
    document.documentElement.removeEventListener('mouseup', stopDrag, false);
  }

  function initDragMobile(e) {
    startX = (event.targetTouches[0] ? event.targetTouches[0].pageX : event.changedTouches[event.changedTouches.length-1].pageX);
    startY = (event.targetTouches[0] ? event.targetTouches[0].pageY : event.changedTouches[event.changedTouches.length-1].pageY);
    startWidth = parseInt(document.defaultView.getComputedStyle(p).width, 10);
    startHeight = parseInt(document.defaultView.getComputedStyle(p).height, 10);
    document.documentElement.addEventListener('touchmove', doDragMobile, false);
    document.documentElement.addEventListener('touchend', stopDragMobile, false);
  }

  function doDragMobile(e) {
    var newY = (event.targetTouches[0] ? event.targetTouches[0].pageY : event.changedTouches[event.changedTouches.length-1].pageY);
    var heightValue = (startHeight - newY + startY);
    wrapper.style.setProperty('height', heightValue + 'px', 'important');
    wrapper.style.setProperty('max-height', heightValue + 'px', 'important');
    p.style.height = heightValue + 'px';
    Cookie.createCookie('height' + fileName, heightValue, 99);
  }

  function stopDragMobile(e) {
    document.documentElement.removeEventListener('touchmove', doDragMobile, false);
    document.documentElement.removeEventListener('touchend', stopDragMobile, false);
  }
}
