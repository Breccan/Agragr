(function() { //Start a closure.

var Req = ({

  reqObj: new Request.JSON(),

  send: function(path, params, callback) {
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

  var hideTopic = function(name) {
    var links = $$('.topic-'+name);
    if (!links) { return; }
    links.addClass('disabled');
  };

  var unhideTopic = function(name) {
    var links = $$('.topic-'+name);
    if (!links) { return; }
    links.removeClass('disabled');
  };

  $('topics').addEvent('click', function(e) {
    var target = e.target;
    if (target.get('tag')!='a') { return; }
    var li   = target.getParent('.topic');
    var name = li.get('id');
    //Toggle whether the class is enabled or disabled.
    if (li.hasClass('disabled')) {
      li.removeClass('disabled');
      unhideTopic(name);
      Req.send('topic/enable/'+name);
    } else {
      li.addClass('disabled'); 
      hideTopic(name);
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

/* Unread Item Count */
var active = true;
var originalTitle = '';
var addUnread = function(n) {
  if (active) { return; }
  if (n<1) { return; }
  var match  = document.title.match(/\((.*)\)$/);
  if (!match) { 
    originalTitle = document.title;
  }
  var unread = (match) ? new Number(match[1])+n : n;
  document.title = originalTitle +' ('+unread+')';
}

var clearUnread = function() {
  active = true;
  document.title = document.title.replace(/\((.*)\)$/, '').trim();
}

/* Clear the unread items when the window is focused. */
window.addEvent('focus', clearUnread);
window.addEvent('blur', function() { active = false; });

update = function() {
  var latest = $$('.loaded-stamp');
  if (!latest || latest.length==0) { return; }
  var stamp = latest[0].get('text');
  new Request.HTML({
    url:'/',
    onSuccess: function(tree,els) {
      var news = els.filter(function(el) {
        return el.match('.news');
      });
      $('news-list').adopt(news, 'top'); 
      addUnread(news.length);
    }
  }).get({since:stamp});
}

update.periodical(30000);

})(); //End fun closure.
