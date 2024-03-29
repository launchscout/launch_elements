import { html, LitElement, css } from 'lit'
import { customElement, property, query, state } from 'lit/decorators.js'
import { liveState, liveStateConfig } from 'phx-live-state';

@customElement('launch-form')
@liveState({
  properties: ['complete'],
  provide: {
    scope: window,
    name: 'launchFormState'
  },
  events: {
    send: ['launch-form-submit'],
    receive: ['livestate-error']
  }
})
export class LaunchFormElement extends LitElement {

  @property()
  @liveStateConfig('url')
  url: string = '';

  @state()
  complete: boolean = false;

  @property({ attribute: 'form-id' })
  formId: string = '';

  @liveStateConfig('topic')
  get topic() { return `launch_form:${this.formId}`; }

  constructor() {
    super();
    this.addEventListener('submit', (ev: SubmitEvent) => {
      ev.preventDefault();
      const formData = Object.fromEntries(new FormData(ev.target as HTMLFormElement));
      if (formData['g-recaptcha-response'] === undefined || formData['g-recaptcha-response'] !== '') {
        delete formData['g-recaptcha-response'];
        this.dispatchEvent(new CustomEvent('launch-form-submit', { detail: formData }));
      }
      console.log(formData);
    });
  }

  render() {
    return this.complete ? html`<slot name="success">Thanks for your submission!</slot>` : html`<slot></slot>`;
  }
}