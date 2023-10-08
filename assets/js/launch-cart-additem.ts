import { html, LitElement } from "lit";
import { customElement, property } from "lit/decorators.js";
import { liveState } from 'phx-live-state';
import cartStyles from '../css/cart.lit.scss';

@customElement('launch-cart-additem')
@liveState({
  events: {
    send: ['add_cart_item'], receive: ['livestate-error']
  },
  context: 'cartState'
})
export class LaunchCartAddItemElement extends LitElement {
  static styles = cartStyles;

  @property({attribute: 'price-id'})
  priceId = '';

  constructor() {
    super();
    this.addEventListener('click', (event) => {
      console.log(event);
      this.dispatchEvent(new CustomEvent('add_cart_item', {detail: {stripe_price: this.priceId}}))
    });
    this.addEventListener('livestate-error', (e: CustomEvent<{ }>) => {
      console.error(e.detail);
    });
  }
  
  render() {
    return html`
    <slot>
      <button part="add-to-cart-button">Add to Cart</button>
    </slot>`;
  }
}
