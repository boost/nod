
window.run = function(dataFeed) {

  console.log(dataFeed);

  var data   = dataFeed.getFeedContent('data') || {};

  // example updating the data field from the data feed
  var criticalNumber = data.criticalNumber || "";
  document.getElementById('data-feed').textContent = criticalNumber;

  // example updating the title from the Field API
  var title = dataFeed.getFieldValue('title') || "";
  document.getElementById('title').textContent = title;
};
