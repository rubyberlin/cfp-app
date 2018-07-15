import Tribute from 'tributejs';
import 'tributejs/scss/tribute.scss';

$(function() {
  const $textarea = $('textarea.mention');

  if ($textarea.length > 0) {
    const values = $textarea
      .data('mention-names')
      .filter(m => m)
      .map(m => ({ value: m, key: m }));

    const tribute = new Tribute({
      values,
      selectTemplate: function(item) {
        if (typeof item === 'undefined') return null;
        if (this.range.isContentEditable(this.current.element)) {
          return `<span contenteditable="false"><a href="" target="_blank" title="${
            item.original.key
          }">${item.original.value}</a></span>`;
        }

        return `@${item.original.value}`;
      }
    });
    tribute.attach($textarea[0]);
  }
});
