createdatabase dev;
use dev;

create table people
(
    id         int,
    name       text,
    birth_date date
);

insert into people
values (1, 'Brunon', '1801-02-03'),
       (2, 'Cedryk', '1885-06-05'),
       (3, 'Kleofas', '1890-11-23');

alter table people
    add constraint primary key t_pk(id);
