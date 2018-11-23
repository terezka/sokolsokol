

class AutoResizeTextArea extends HTMLElement {
  static get observedAttributes() { return ["data-autoresize", "data-value", "data-placeholder"]; }

  constructor() {
    super();
    this._textarea = document.createElement('textarea');
    this._autoresize = false;
    this._updateListener.bind(this);
    this._resize.bind(this);
  }

  attributeChangedCallback(name, previous, next) {
    if (name === "data-autoresize") {
      this._autoresize = next !== null;
      if (!this._textarea) return;
      this._updateListener();
    } else if (name == "data-value") {
      if (!this._textarea) return;
      this._textarea.value = this.getAttribute("data-value");
      this._updateListener();
    } else if (name == "data-placeholder") {
      if (!this._textarea) return;
      this._textarea.placeholder = this.getAttribute("data-placeholder");
      this._updateListener();
    }
  }

  connectedCallback() {
    this._updateListener();
    this.appendChild(this._textarea);
  }

  _updateListener() {
    if (this._autoresize) {
      this._textarea.addEventListener('input', this._resize.bind(this));
      this._resize()
    } else {
      this._textarea.removeEventListener('input', this._resize.bind(this));
    }
  }

  _resize() {
    setTimeout(() => {
      var minHeight = null;
      if (this._textarea.style.minHeight) {
        minHeight = parseInt(this._textarea.style.minHeight, 10);
      } else {
        minHeight = parseInt(window.getComputedStyle(this._textarea).minHeight, 10);
      }
      if (minHeight === 0) {
        minHeight = parseInt(window.getComputedStyle(this._textarea).height, 10);
      }

      this._textarea.style.resize = "none";
      this._textarea.style.outline = "none";
      this._textarea.style.border = "none";
      this._textarea.style.textDecoration = "inherit";
      this._textarea.style.fontSize = "inherit";
      this._textarea.style.fontWeight = "inherit";
      this._textarea.style.width = "100%";
      this._textarea.style.overflowY = "hidden";
      this._textarea.style.minHeight = minHeight + "px";
      this._textarea.style.transition = "none";
      if (this._textarea.scrollHeight > minHeight) {
        this._textarea.style.height = minHeight + "px";
        this._textarea.style.height = this._textarea.scrollHeight + "px";
      } else {
        this._textarea.style.height = minHeight + "px";
      }
    }, 0);
  }
}

customElements.define("autoresize-textarea", AutoResizeTextArea);
