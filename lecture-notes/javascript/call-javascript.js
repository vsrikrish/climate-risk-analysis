// Idea taken from http://docs.mathjax.org/en/latest/web/configuration.html and https://github.com/jonathanlilly/liminal

//Call remark.js 

remark.macros.img = function (altText, width) {
    var url = this;
    return '<img alt="' + altText + '" src="' + url + '" style="width: ' + width + '" />';
};

remark.macros.link = function (text) {
    var url = this;
    return '<a href="' + url  + '" target="_blank"/>' + text + '</a>';
};

var slideshow = remark.create({
    ratio: '16:9',
    navigation: {
        click: false,
        scroll: false
    },
    properties: {
        class: "center, middle"
    },
    countIncrementalSlides: false,
    highlightLanguage: 'julia',
    highlightStyle: 'googlecode'
});

