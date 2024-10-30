CREATE TABLE public.items(
	id INT PRIMARY KEY,
	name VARCHAR(250),
	brand VARCHAR(250),
	variant VARCHAR(250),
	category VARCHAR(250),
	price_in_usd NUMERIC
);

CREATE TABLE public.users(
	id INT PRIMARY KEY,
	ltv INT,
	date TIMESTAMP
);

CREATE TABLE public.events_1(
	user_id INT REFERENCES public.users(id),
	ga_session_id INT,
	country VARCHAR(250),
	device VARCHAR(250),
	type VARCHAR(250),
	item_id INT REFERENCES public.items,
	date TIMESTAMP
);

ALTER TABLE public.events_1 OWNER to postgres;
ALTER TABLE public.items OWNER to postgres;
ALTER TABLE public.users OWNER to postgres;

CREATE INDEX idx_user_id ON public.events_1(user_id);
CREATE INDEX idx_item_id ON public.events_1(item_id);