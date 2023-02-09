import '../js/launch-cart';
import { expect } from "@esm-bundle/chai";
import { LaunchCartElement, Cart, CartItem } from '../js/launch-cart';
import { fixture } from '@open-wc/testing';
import LiveState from 'phx-live-state';
import sinon from 'sinon';

describe('launch-cart test', async () => {
  let cart: Cart;
  beforeEach(() => {
    cart = {
      total: 5,
      items: [
        {
          quantity: 2,
          id: 'abc',
          product: {
            id: 'prod1',
            name: 'Bob',
            description: 'hi',
            images: []
          },
          price: 1.23
        },
        {
          quantity: 3,
          id: 'abc',
          product: {
            id: 'prod1',
            name: 'Bob',
            description: 'hi',
            images: []
          },
          price: 1.23
        }
      ]
    }
  });
  it('renders', async () => {
    window['cartState'] = sinon.createStubInstance(LiveState);
    const launchCart: LaunchCartElement = await fixture('<launch-cart url="wss://foo.bar"></launch-cart>');
    launchCart.cart =  cart;
    await launchCart.updateComplete;
    expect(launchCart.shadowRoot.querySelector("span.cart-count").textContent).to.equal('5');
  })
})
