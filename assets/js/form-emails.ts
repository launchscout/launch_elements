import { html, LitElement, css } from 'lit'
import { customElement, property, query, state } from 'lit/decorators.js'

type FormEmail = {
  id?: number;
  subject: string;
  email: string;
}

@customElement('form-emails')
export class FormEmailsElement extends LitElement {

  constructor() {
    super();
    window.addEventListener("phx:saved-form-email", (evt) => {
      this.dialog?.close();
    })
  }

  @property({type: Array, attribute: 'form-emails'})
  formEmails: Array<FormEmail> = [];

  @state()
  formEmail: FormEmail = null;

  @query("dialog")
  dialog: HTMLDialogElement;

  @query("form")
  form: HTMLFormElement;

  render() {
    return html`
    <h2>Email form submissions</h2>
      <dialog>
        <form @submit=${this.saveFormEmail}>
          <div>
            <label for="subject">Subject</label>
            <input name="subject" value=${this.formEmail?.subject}/>
          </div>
          <div>
            <label for="email">Email</label>
            <input name="email" value=${this.formEmail?.email}/>
          </div>
          <button id="save-form-email">Save</button>
        </form>
      </dialog>
      <table>
        <thead>
          <tr>
            <th>Subject</th>
            <th>Email</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          ${this.formEmails.map(formEmail => html`
            <tr>
              <td>${formEmail.subject}</td>
              <td>${formEmail.email}</td>
              <td><button @click=${this.editFormEmail} data-form-email-id=${formEmail.id}>Edit</button></td>
            </tr>
          `)}
        </tbody>
      </table>
      <button id="add-form-email" @click=${this.newFormEmail}>Add new email response</button>
    `;
  }

  newFormEmail(_event) {
    this.formEmail = {subject: '', email: ''};
    this.form.reset();
    this.dialog.show();
  }

  editFormEmail(event) {
    this.formEmail = this.formEmails.find((formEmail) => formEmail.id == event.target.dataset.formEmailId);
    this.form.reset();
    this.dialog.show();
  }
 
  saveFormEmail(event) {
    event.preventDefault();
    const formData = Object.fromEntries(new FormData(event.target as HTMLFormElement));
    this.dispatchEvent(new CustomEvent('save-form-email', {detail: {id: this.formEmail.id, ...formData}}));
  }
}