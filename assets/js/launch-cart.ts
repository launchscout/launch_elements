import { html, LitElement } from 'lit'
import { customElement, property, query, state } from 'lit/decorators.js'
import { liveState, liveStateConfig } from 'phx-live-state';
import '@shoelace-style/shoelace';
import shoelace_light from '@shoelace-style/shoelace/dist/themes/light.styles.js';
import { setBasePath } from '@shoelace-style/shoelace';
setBasePath('https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.0.0-beta.86/dist/')

type CartItem = {
  id: string;
  product: Product;
  quantity: number;
  price: number
}

type Product = {
  description: string;
  id: string;
  images: string[];
  name: string;
}

type Cart = {
  items: Array<CartItem>;
  total: number;
}

const formatPrice = (price) => {
  return price > 0 ? new Intl.NumberFormat('en-us', {style: 'currency', currency: 'USD'}).format(price / 100) : '';
}

@customElement('launch-cart')
@liveState({
  properties: ['cart'],
  provide: {
    scope: window,
    name: 'cartState'
  },
  events: {
    send: ['checkout', 'remove_cart_item'],
    receive: ['checkout_redirect', 'cart_created', 'checkout_complete']
  }
})
export class LaunchCartElement extends LitElement {

  static styles = [shoelace_light];

  @property()
  @liveStateConfig('url')
  url: string | undefined;
  
  @property({attribute: "store-id"})
  storeId: string;

  @state()
  cart: Cart | undefined;

  @query('sl-dialog#cart-details')
  cartDetails: HTMLElement | undefined;

  @query('sl-dialog#thank-you')
  thanks: HTMLElement | undefined;

  @liveStateConfig('topic')
  get topic() {
    return `launch_cart:${this.storeId}`;
  }

  @liveStateConfig('params.cart_id')
  get channelName() { 
    const cartId =  window.localStorage.getItem('cart_id');
    return cartId ? cartId : ''
  }

  constructor() {
    super();
    this.addEventListener('checkout_redirect', (e: CustomEvent<{ checkout_url: string }>) => {
      window.location.href = e.detail.checkout_url;
    });
    this.addEventListener('checkout_complete', (e: CustomEvent) => {
      this.showThanks();
      window.localStorage.removeItem('cart_id');
    });
    this.addEventListener('cart_created', (e: CustomEvent<{ cart_id: string }>) => {
      console.log('cart created')
      window.localStorage.setItem('cart_id', e.detail.cart_id);
    });
  }

  itemCount() {
    return this.cart && this.cart.items && this.cart.items.length > 0 ? html`
      <sl-badge pill>${this.cart.items.length}</sl-badge>
    ` : ``;
  }

  expandCart() {
    this.cartDetails && (this.cartDetails as any).show();
  }

  showThanks() {
    this.thanks && (this.thanks as any).show();
  }

  removeItem(e: MouseEvent) {
    const itemId = (e.target as HTMLElement).dataset.itemId;
    this.dispatchEvent(new CustomEvent('remove_cart_item', {detail: {item_id: itemId}}))
  }

  render() {
    return html`
    <sl-dialog id="thank-you">
      Thanks for purchasing!
    </sl-dialog>
    <sl-dialog id="cart-details">
      <table>
        <thead>
          <tr>
            <th>Item</th>
            <th>Quantity</th>
            <th>Price</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          ${this.cart?.items.map(item => html`
          <tr>
            <td>${item.product.name}</td>
            <td>${item.quantity}</td>
            <td>${formatPrice(item.price)}</td>
            <td><sl-button data-item-id=${item.id} id="remove-item" @click=${this.removeItem}>Remove</sl-button></td>
          </tr>
          `)}
        </tbody>
      </table>
      <sl-button @click=${this.checkout}>Check out</sl-button>
    </sl-dialog>
    <sl-button @click=${this.expandCart}>
      <slot name="icon"><sl-icon name="cart" style="font-size: 2em;"></sl-icon></slot>
      ${this.itemCount()}
    </sl-button>
    `;
  }

  checkout(_e: Event) {
    this.dispatchEvent(new CustomEvent('checkout', { detail: { return_url: window.location.href } }))
  }

}

declare global {
  interface HTMLElementEventMap {
    'checkout_redirect': CustomEvent<{ checkout_url: string }>;
  }
}