import {
  trigger,
  state,
  style,
  animate,
  group,
  transition,
  query,
  animateChild
} from '@angular/animations';
export const slideInAnimation = trigger('routeAnimations', [
  transition('ShowResult <=> Detail', [
    style({ position: 'relative' }),
    query(':enter, :leave', [
      style({
        position: 'absolute',
        top: 0,
        left: 0,
        width: '100%'
      })
    ]),
    query(':enter', [style({ left: '-100%' })]),
    query(':leave', animateChild()),
    group([
      query(':leave', [animate('500ms ease-in-out', style({ left: '100%' }))]),
      query(':enter', [animate('500ms ease-in-out', style({ left: '0%' }))])
    ]),
    query(':enter', animateChild())
  ]),
  transition('Wishlist <=> Detail', [
    style({ position: 'relative' }),
    query(':enter, :leave', [
      style({
        position: 'absolute',
        top: 0,
        left: 0,
        width: '100%'
      })
    ]),
    query(':enter', [style({ left: '-100%' })]),
    query(':leave', animateChild()),
    group([
      query(':leave', [animate('500ms ease-in-out', style({ left: '100%' }))]),
      query(':enter', [animate('500ms ease-in-out', style({ left: '0%' }))])
    ]),
    query(':enter', animateChild())
  ])
]);
