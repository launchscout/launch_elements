import { html, LitElement, css } from 'lit'
import { customElement, property, query, state } from 'lit/decorators.js'
import { liveState, liveStateConfig } from 'phx-live-state';

@customElement('launch-form')
@liveState({
  topic: 'launch_form:all',
  properties: ['complete'],
  provide: {
    scope: window,
    name: 'launchFormState'
  },
  events: {
    send: ['launch-form-submit']
  }
})
export class LaunchFormElement extends LitElement {

  @property()
  @liveStateConfig('url')
  url: string = '';

  @state()
  complete: boolean = false;

  constructor() {
    super();
    this.addEventListener('submit', (ev: SubmitEvent) => {
      ev.preventDefault();
      const formData = Object.fromEntries(new FormData(ev.target as HTMLFormElement)) ;
      console.log(formData);
      this.dispatchEvent(new CustomEvent('launch-form-submit', { detail: formData}));
    });
  }

  render() {
    return this.complete ? html`<slot name="success"></slot>` : html`<slot></slot>`;
  }
}