export class LaunchRecaptchaElement extends HTMLElement {
  
  connectedCallback() {
    if (!document.querySelector('#recaptcha-script')) {
      const script = document.createElement('script');
      script.id = 'recaptcha-script';
      script.src = 'https://www.google.com/recaptcha/api.js';
      document.head.appendChild(script);
    }
    this.innerHTML = `<div class="g-recaptcha" data-sitekey="${this.getAttribute('site-key')}" id="recaptcha"></div>`;
  }
  
}

customElements.define('launch-recaptcha', LaunchRecaptchaElement);