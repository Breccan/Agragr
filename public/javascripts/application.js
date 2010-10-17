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
  });

  //Remove event to the filter list.
  $('selected-filters').addEvent('click', function(e) {
    e.stop();
    if (e.target.get('tag')=='a') { e.target.getParent('li').dispose(); }
  });

}
