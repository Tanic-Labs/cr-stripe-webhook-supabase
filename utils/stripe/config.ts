import Stripe from "npm:stripe@^13.0.0";
export const stripe = new Stripe(Deno.env.get('STRIPE_PUBLIC_KEY'), {
    apiVersion: "2023-10-16",
});
