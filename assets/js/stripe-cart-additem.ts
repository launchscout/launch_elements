import { html, LitElement } from "lit";
import { customElement, property } from "lit/decorators.js";
import { liveState } from 'phx-live-state';

@customElement('stripe-cart-additem')
@liveState({
  events: {
    send: ['add_cart_item']
  },
  context: 'cartState'
})
export class StripeCartAddItemElement extends LitElement {

  @property({attribute: 'price-id'})
  priceId = '';

  constructor() {
    super();
    this.addEventListener('click', (event) => {
      console.log(event);
      this.dispatchEvent(new CustomEvent('add_cart_item', {detail: {stripe_price: this.priceId}}))
    });
  }
  
  render() {
    return html`<slot></slot>`;
  }
}
