"""The languages as generated: each is locales/registry.json's row, in its order."""

from typing import get_args

from spec import SPEC, objects, read, text

from xynolog.locales import LOCALE_CODES, LOCALES, LocaleCode


def test_each_language_is_its_rows_code_native_name_and_english_name_in_the_registrys_order() -> None:
    rows = objects(read(SPEC / "locales/registry.json")["locales"], "locales")
    codes = [text(row["code"], "a code") for row in rows]
    assert list(LOCALE_CODES) == codes
    assert list(get_args(LocaleCode.__value__)) == codes
    assert [(held.code, held.native_name, held.english_name) for held in LOCALES] == [
        (row["code"], row["nativeName"], row["englishName"]) for row in rows
    ]
