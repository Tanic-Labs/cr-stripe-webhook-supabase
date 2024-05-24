import Stripe from "npm:stripe@^13.0.0";
import { stripe } from './utils/stripe/config.ts';
import { updatePremiumCredits } from './utils/supabase/admin.ts';

const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET');

// Handler function for webhook events
async function handler(req: Request) {
    const body = await req.text();
    const sig = req.headers.get('stripe-signature') as string;
    let event: Stripe.Event;

    try {
        if (!sig || !webhookSecret)
            return new Response('Webhook secret not found.', { status: 400 });

        event = await stripe.webhooks.constructEventAsync(body, sig, webhookSecret);
        console.log(`🔔  Webhook received: ${event.type}`);
    } catch (err: any) {
        console.log(`❌ Error message: ${err.message}`);
        return new Response(`Webhook Error: ${err.message}`, { status: 400 });
    }

    if (event.type === 'checkout.session.completed') {
        try {
            const checkoutSession = event.data.object as Stripe.Checkout.Session;

            // Update premium credits in Supabase
            await updatePremiumCredits(checkoutSession.customer as string);

            return new Response(JSON.stringify({ received: true }));
        } catch (error) {
            console.log(error);
            return new Response('Webhook handler failed. View your function logs.', { status: 400 });
        }
    } else {
        return new Response(`Unsupported event type: ${event.type}`, { status: 400 });
    }
}

Deno.serve((req: Request) => handler(req));
