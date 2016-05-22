set -o errexit
set -o pipefail
set -o nounset

create-db () {
sqlite3 "$1" << end-of-file
DROP VIEW IF EXISTS bdays;
DROP TABLE IF EXISTS birthday_name;
CREATE TABLE birthday_name (
  birthday TEXT NOT NULL,
  name TEXT NOT NULL
);
.separator "\t"
.import $2 birthday_name
CREATE VIEW bdays (
  birthday,
  name,
  age,
  days_left
)
AS SELECT
  birthday,
  name,
  strftime('%Y', 'now') - strftime('%Y', birthday),
  (strftime('%j', birthday) - strftime('%j', 'now') + 365) % 365
FROM birthday_name;
end-of-file
}

show-all () {
sqlite3 "$1" << end-of-file
.headers on
.mode column
.width 0 20 5
SELECT
  strftime('%d.%m', birthday) AS date,
  name,
  age
FROM bdays
ORDER BY days_left;
end-of-file
}

show-full () {
sqlite3 "$1" << end-of-file
.headers on
.mode column
SELECT * FROM bdays
ORDER BY strftime('%m%d', birthday);
end-of-file
}

show-upcoming () {
sqlite3 "$1" << end-of-file
.headers on
.mode column
.width 0 20 5 0
SELECT
  strftime('%d.%m', birthday) date,
  name,
  age,
  days_left
FROM bdays
WHERE days_left < 23
ORDER BY days_left;
end-of-file
}

DEFAULT_DB=bdays.db
DEFAULT_TXT=bdays.tsv

case ${1:-upcoming} in
create)
    create-db "${2:-$DEFAULT_DB}" "${3:-$DEFAULT_TXT}"
    ;;
upcoming)
    show-upcoming "${2:-$DEFAULT_DB}"
    ;;
all)
    show-all "${2:-$DEFAULT_DB}"
    ;;
full)
    show-full "${2:-$DEFAULT_DB}"
esac

