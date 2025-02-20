-- load extension first time after install
CREATE EXTENSION mysql_fdw;

-- create server object
CREATE SERVER mysql_server
    FOREIGN DATA WRAPPER mysql_fdw
    OPTIONS (host 'mysql', port '3306');

-- create user mapping
CREATE USER MAPPING FOR postgres
    SERVER mysql_server
    OPTIONS (username 'root', password 'root');

do $$
    declare
        v_steps  int := 12;
        v_sleep  int := 5;
        idx      int;
    begin
        for idx in 1..v_steps
            loop
                begin
                    CREATE FOREIGN TABLE mysql_people
                        (
                            id         int,
                            name       text,
                            birth_date date
                            )
                        SERVER mysql_server
                        OPTIONS (dbname 'dev', table_name 'people');

                    CREATE MATERIALIZED VIEW people
                    AS
                    SELECT name, extract(year from now()) - extract(year from birth_date) age
                    FROM mysql_people;

                    exit;
                exception
                    when others then
                        raise warning using message = 'mysql db is not initialized yet. sleeping for ' || v_sleep || ' seconds...';
                        perform pg_sleep(v_sleep);
                end;
            end loop;
    end;
$$;
