

class AutoResizeTextArea extends HTMLElement {
  static get observedAttributes() { return ["data-value"]; }

  constructor() {
    super();
    this._resize = this._resize.bind(this);

    this._textarea = document.createElement('textarea');
    this._textarea.addEventListener('input', this._resize);
    this._textarea.addEventListener('paste', this._resize);

    this._textarea.style.resize = "none";
    this._textarea.style.outline = "none";
    this._textarea.style.border = "none";
    this._textarea.style.textDecoration = "inherit";
    this._textarea.style.fontWeight = "inherit";
    this._textarea.style.fontSize = "inherit";
    this._textarea.style.width = "100%";
    this._textarea.style.overflowY = "hidden";
    this._textarea.style.transition = "none";
    this._textarea.style.padding = "0";
  }

  attributeChangedCallback(name, previous, next) {
    if (name == "data-value") {
      this._textarea.value = this.getAttribute("data-value");
      this._resize();
    } else if (name == "data-placeholder") {
      this._textarea.placeholder = this.getAttribute("data-placeholder");
    }
  }

  connectedCallback() {
    this.appendChild(this._textarea);

    this._textarea.rows = 1;
    this._textarea.baseHeight = this._textarea.offsetHeight;
    this._textarea.rows = undefined;
  }

  _resize() {
    setTimeout(() => {
      this._textarea.rows = undefined;
      var rows = Math.ceil(this._textarea.scrollHeight / this._textarea.baseHeight);
      if (this._textarea.rows !== rows) {
        this._textarea.rows = rows;
      }
    }, 0);
  }
}

customElements.define("autoresize-textarea", AutoResizeTextArea);
