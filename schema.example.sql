create table
  public.customers (
    id uuid not null,
    stripe_customer_id text null,
    constraint customers_pkey primary key (id),
    constraint customers_id_fkey foreign key (id) references auth.users (id)
  ) tablespace pg_default;

create table
  public.prices (
    id text not null,
    product_id text null,
    active boolean null,
    description text null,
    unit_amount bigint null,
    currency text null,
    type public.pricing_type null,
    interval public.pricing_plan_interval null,
    interval_count integer null,
    trial_period_days integer null,
    metadata jsonb null,
    constraint prices_pkey primary key (id),
    constraint prices_product_id_fkey foreign key (product_id) references products (id),
    constraint prices_currency_check check ((char_length(currency) = 3))
  ) tablespace pg_default;

create table
  public.products (
    id text not null,
    active boolean null,
    name text null,
    description text null,
    image text null,
    metadata jsonb null,
    constraint products_pkey primary key (id)
  ) tablespace pg_default;

create table
  public.subscriptions (
    id text not null,
    user_id uuid not null,
    status public.subscription_status null,
    metadata jsonb null,
    price_id text null,
    quantity integer null,
    cancel_at_period_end boolean null,
    created timestamp with time zone not null default timezone ('utc'::text, now()),
    current_period_start timestamp with time zone not null default timezone ('utc'::text, now()),
    current_period_end timestamp with time zone not null default timezone ('utc'::text, now()),
    ended_at timestamp with time zone null default timezone ('utc'::text, now()),
    cancel_at timestamp with time zone null default timezone ('utc'::text, now()),
    canceled_at timestamp with time zone null default timezone ('utc'::text, now()),
    trial_start timestamp with time zone null default timezone ('utc'::text, now()),
    trial_end timestamp with time zone null default timezone ('utc'::text, now()),
    constraint subscriptions_pkey primary key (id),
    constraint subscriptions_price_id_fkey foreign key (price_id) references prices (id),
    constraint subscriptions_user_id_fkey foreign key (user_id) references auth.users (id)
  ) tablespace pg_default;