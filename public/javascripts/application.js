(function() { //Start a closure.

var Req = ({

  reqObj: new Request.JSON(),

  send: function(path, params, callback) {
    if (!path.match(/^\//)) { path = '/'+path; }
    if (!params)   params = {};
    if (!callback) callback = function() { };
    this.reqObj.send({url:path, data:params, onSuccess: callback});
  }

});


var latestStamp = new Number($$('.news .loaded-stamp')[0].get('text'));
var addLinks = function(tree,els) {

  var news = els.filter(function(el) {
    if (!el.match('.news')) { return false; }
    var stamp = el.getElement('.loaded-stamp');
    if (!stamp) { return; }
    stamp = new Number(stamp.get('text'));
    if (latestStamp < stamp) {
      latestStamp = stamp;
    } else {
      console.log(latestStamp +">"+ new Number(stamp));
    }
    return true;
  });

  news.inject($('news-items'), 'top');
  console.log(news);
  news.addClass('recent');
  addUnread(news.length);

};

var update = function() {
  new Request.HTML({
    url:'/',
    onSuccess:addLinks
  }).get({since:latestStamp});
}

update.periodical(30000);

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
      var stamp = li.getElement('span.loaded-stamp');
      if (stamp) {
        stamp = stamp.get('text');
      }
      unhideTopic(name);
      Req.send('topic/enable/'+name, {'since':stamp});
    } else {
      li.addClass('disabled'); 
      li.adopt(new Element('span.loaded-stamp').set('text', new Date().getTime()));
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
  (function() {
    $$('.recent').set('tween', {'duration':'long'})
                 .tween('background-color', '#ededed');
  }).delay(10000);
}

/* Clear the unread items when the window is focused. */
document.body.addEvent('mouseenter', clearUnread);
document.body.addEvent('mouseleave', function() { active = false; });

})(); //End fun closure.
