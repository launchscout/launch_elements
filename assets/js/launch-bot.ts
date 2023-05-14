import { html, LitElement, css } from 'lit'
import { customElement, property, query, state } from 'lit/decorators.js'
import { liveState, liveStateConfig } from 'phx-live-state';

@customElement('launch-bot')
@liveState({
  properties: ['conversation'],
  events: {
    send: ['add_message']
  }
})
export class LaunchFormElement extends LitElement {

  @property()
  @liveStateConfig('url')
  url: string = '';

  @state()
  conversation: Array<any> = [];

  @property({attribute: 'bot-id'})
  botId: string = '';

  @query('#message-text')
  messageText: HTMLInputElement | undefined;

  @liveStateConfig('topic')
  get topic() {return `launch_bot:${this.botId}`;}

  sendMessage(ev: Event) {
    ev.preventDefault();
    this.dispatchEvent(new CustomEvent('add_message', { detail: {text: this.messageText?.value}}));
    this.messageText!.value = '';
  }

  render() {
    return html `
      <ul>
        ${this.conversation && this.conversation.map((message: any) => html`
          <li>${message.role}</li>
          <li>${message.content}</li>
        `)}
      </ul>
      <form>
        <input type="text" id="message-text" name="message" />
        <button @click=${this.sendMessage}>Send</button>
      </form>
    `;
  }
}