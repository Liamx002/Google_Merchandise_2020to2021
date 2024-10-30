SELECT
    event.country,
    event.device,
    event.type,
    event.date,
    item.name,
    item.brand,
    item.variant,
    item.category,
    item.price_in_usd,
    userss.ltv,
    userss.date AS user_date

FROM public.events_1 AS event
    LEFT JOIN public.items AS item ON event.item_id = item.id
    LEFT JOIN public.users AS userss ON event.user_id = userss.id;