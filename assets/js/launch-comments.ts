import { html, LitElement, css } from 'lit'
import { customElement, property, query, state } from 'lit/decorators.js'
import { liveState, liveStateConfig, liveStateProperty } from 'phx-live-state';

type Comment = {
  author: string;
  inserted_at: Date;
  comment: string;
}

@customElement('launch-comments')
@liveState({
  properties: ['comments'],
  provide: {
    scope: window,
    name: 'launchCommentsState'
  },
  events: {
    send: ['add_comment'],
    receive: ['comment_added']
  }
})
export class LaunchCommentsElement extends LitElement {

  @property()
  @liveStateConfig('url')
  url: string = '';

  @state()
  comments: Array<Comment> = [];

  @property({ attribute: 'site-id' })
  siteId: string = '';

  @liveStateConfig('topic')
  get topic() { return `launch_comments:${this.siteId}`; }

  @liveStateConfig('params.url')
  get pageUrl() { return window.location.href; }

  @state()
  @liveStateProperty('/requires_approval')
  approvalRequired: boolean = false;

  @query('input[name="author"]')
  author: HTMLInputElement | undefined;

  @query('textarea[name="comment"]')
  comment: HTMLTextAreaElement | undefined;

  dateTimeFormatter = new Intl.DateTimeFormat('default');

  addComment(e: Event) {
    this.dispatchEvent(new CustomEvent('add_comment', {
      detail: {
        author: this.author?.value,
        comment: this.comment?.value,
        url: window.location.href,
        comment_site_id: this.siteId
      }
    }));
    e.preventDefault();
  }

  constructor() {
    super();
    this.addEventListener("comment_added", (e) => {
      console.log(e);
      this.clearNewComment();
    });
  }

  clearNewComment() {
    this.author!.value = '';
    this.comment!.value = '';
  }

  formatDateTime(dateTime) {
    const createdAt = new Date()
    createdAt.setTime(Date.parse(dateTime))
    return this.dateTimeFormatter.format(createdAt);
  }

  render() {
    return html`
      <div part="previous-comments">
        ${this.comments?.map(comment => html`
        <div part="comment">
          <div part="comment-text">${comment.comment}</div>
          <div part="byline">
            <span part="comment-author">${comment.author}</span> on <span
              part="comment-created-at">${this.formatDateTime(comment.inserted_at)}</span>
          </div>
        </div>
        `)}
      </div>
      <div part="new-comment">
        ${this.approvalRequired ? html`<slot name="approval-notice"><div>Your comments will appear after approval by the moderator</div></slog>` : ``}
        <form part="form" @submit=${this.addComment}>
          <div part="comment-field-author">
            <label part="author-label" for="author">Author</label>
            <input part="author-input" id="author" name="author" required>
          </div>
          <div part="comment-field-text">
            <label part="comment-label" for="comment">Comment</label>
            <textarea part="comment-input" id="comment" name="comment" required></textarea>
          </div>
          <button part="add-comment-button">Add Comment</button>
        </form>
      </div>
    `;
  }

}