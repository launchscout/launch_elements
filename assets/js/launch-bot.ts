import { html, LitElement, css } from 'lit'
import { customElement, property, query, state } from 'lit/decorators.js'
import { liveState, liveStateConfig } from 'phx-live-state';
import cartStyles from '../css/cart.lit.scss';


interface Message {
  role: string;
  content: string;
}

@customElement('launch-bot')
@liveState({
  properties: ['conversation'],
  events: {
    send: ['add_message']
  }
})


export class LaunchFormElement extends LitElement {
  static styles = cartStyles;

  @property()
  @liveStateConfig('url')
  url: string = '';

  @state()
  conversation: Array<Message> = [];

  @property({attribute: 'bot-id'})
  botId: string = '';

  @query('#message-text')
  messageText: HTMLInputElement | undefined;

  @liveStateConfig('topic')
  get topic() {return `launch_bot:${this.botId}`;}

  sendMessage(ev: Event) {
    ev.preventDefault();
    console.log(this.conversation)
    this.dispatchEvent(new CustomEvent('add_message', { detail: {text: this.messageText?.value}}));
    this.messageText!.value = '';
  }

  render() {
    return html `
      <ul>
        ${this.conversation && this.conversation.map((message: Message) => html`
          <li part="message">
            <span part="message-tag">${message.role}</span>
            <div part="message-content">${message.content}</div>
          </li>
        `)}
      </ul>
      <form>
        <input type="text" id="message-text" name="message" />
        <button @click=${this.sendMessage}>Send</button>
      </form>
    `;
  }

}