import { html, LitElement, css } from 'lit'
import { customElement, property, query, state } from 'lit/decorators.js'

type WebHook = {
  id?: number;
  description: string;
  url: string;
}

@customElement('web-hooks')
class WebHooksElement extends LitElement {

  constructor() {
    super();
    window.addEventListener("phx:saved-web-hook", (evt) => {
      this.dialog?.close();
    })
  }

  @property({type: Array, attribute: 'web-hooks'})
  webHooks: Array<WebHook> = [];

  @state()
  webHook: WebHook = null;

  @query("dialog")
  dialog: HTMLDialogElement;

  @query("form")
  form: HTMLFormElement;

  render() {
    return html`
    <h2>Web hooks</h2>
      <dialog>
        <form @submit=${this.saveWebHook}>
          <div>
            <label for="description">Description</label>
            <input name="description" value=${this.webHook?.description}/>
          </div>
          <div>
            <label for="url">URL</label>
            <input name="url" value=${this.webHook?.url}/>
          </div>
          <button id="save-web-hook">Save</button>
        </form>
      </dialog>
      <table>
        <thead>
          <tr>
            <th>Description</th>
            <th>URL</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          ${this.webHooks.map(webHook => html`
            <tr>
              <td>${webHook.description}</td>
              <td>${webHook.url}</td>
              <td><button @click=${this.editWebHook} data-web-hook-id=${webHook.id}>Edit</button></td>
            </tr>
          `)}
        </tbody>
      </table>
      <button id="add-web-hook" @click=${this.newWebHook}>Add new web hook</button>
    `;
  }

  newWebHook(_event) {
    this.webHook = {description: '', url: ''};
    this.form.reset();
    this.dialog.show();
  }

  editWebHook(event) {
    this.webHook = this.webHooks.find((webHook) => webHook.id == event.target.dataset.webHookId);
    this.form.reset();
    this.dialog.show();
  }
 
  saveWebHook(event) {
    event.preventDefault();
    const formData = Object.fromEntries(new FormData(event.target as HTMLFormElement));
    this.dispatchEvent(new CustomEvent('save-web-hook', {detail: {id: this.webHook.id, ...formData}}));
  }
}