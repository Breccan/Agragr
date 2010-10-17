(function() { //Start a closure.

var Req = ({

  reqObj: new Request.JSON(),

  send: function(path, params) {
    if (!path.match(/^\//)) { path = '/'+path; }
    if (!params) { params = {}; }
    params.url = path;
    this.reqObj.post(params);
  }

});

/**
 * Topic Toggling
 */
if ($('topics')) {

  $('topics').addEvent('click', function(e) {
    var target = e.target;
    if (target.get('tag')!='a') { return; }
    var li   = target.getParent('.topic');
    var name = li.get('id');
    //Toggle whether the class is enabled or disabled.
    if (li.hasClass('disabled')) {
      li.removeClass('disabled');
      Req.send('topic/enable/'+name);
    } else {
      li.addClass('disabled'); 
      Req.send('topic/disable/'+name);
   }
  });

}

/**
 * Filter Controls
 */
if ($('filter')) {

  //Submit event to the add filter form.
  $('filter').getElement('form').addEvent('submit', function(e) {
    e.stop();
    var filter = $('filter-list').getElement('option:selected');
    var text   = filter.get('text');
    var name   = filter.get('value');
    if ($(name)) { return; }
    var a = new Element('a', {text:text, id:name, href:'#'});
    $('selected-filters').adopt(new Element('li').adopt(a));
    Req.send('filter/enable/'+name);
  });

  //Remove event to the filter list.
  $('selected-filters').addEvent('click', function(e) {
    e.stop();
    if (e.target.get('tag')=='a') {
      var name = e.target.get('id');
      e.target.getParent('li').dispose();
      Req.send('filter/disable/'+name);
    }

  });

}

})(); //End fun closure.
