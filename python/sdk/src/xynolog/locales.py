# Generated from protocol/specs/src/locales/registry.json; do not edit.
# Regenerate: make generate (codegen/lib/python_types/python_types.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The languages Xynolog supports: each one's code, what it calls itself, and its name in English.
A person reads the interface in one of them, a resource is written in one, and a model is told
which by its English name.
"""

from dataclasses import dataclass
from typing import Final, Literal, final

__all__ = [
    "LOCALES",
    "LOCALE_CODES",
    "LocaleCode",
    "LocaleInfo",
]

type LocaleCode = Literal[
    "ar",
    "bn",
    "cs",
    "da",
    "de",
    "el",
    "en",
    "es",
    "fa",
    "fi",
    "fr",
    "he",
    "hi",
    "id",
    "it",
    "ja",
    "ko",
    "ms",
    "nl",
    "no",
    "pl",
    "pt",
    "ro",
    "sv",
    "th",
    "tr",
    "uk",
    "vi",
    "zh",
]
"""The code of a supported language."""

LOCALE_CODES: Final[tuple[LocaleCode, ...]] = (
    "ar",
    "bn",
    "cs",
    "da",
    "de",
    "el",
    "en",
    "es",
    "fa",
    "fi",
    "fr",
    "he",
    "hi",
    "id",
    "it",
    "ja",
    "ko",
    "ms",
    "nl",
    "no",
    "pl",
    "pt",
    "ro",
    "sv",
    "th",
    "tr",
    "uk",
    "vi",
    "zh",
)
"""The code of every supported language, in the registry's order."""


@final
@dataclass(frozen=True, slots=True, kw_only=True)
class LocaleInfo:
    """A supported language: its code, what it calls itself, and its name in English."""

    code: LocaleCode
    native_name: str
    english_name: str
    """What a model is told a text is written in."""


LOCALES: Final[tuple[LocaleInfo, ...]] = (
    LocaleInfo(code="ar", native_name="\u0627\u0644\u0639\u0631\u0628\u064a\u0629", english_name="Arabic"),
    LocaleInfo(code="bn", native_name="\u09ac\u09be\u0982\u09b2\u09be", english_name="Bengali"),
    LocaleInfo(code="cs", native_name="\u010ce\u0161tina", english_name="Czech"),
    LocaleInfo(code="da", native_name="Dansk", english_name="Danish"),
    LocaleInfo(code="de", native_name="Deutsch", english_name="German"),
    LocaleInfo(code="el", native_name="\u0395\u03bb\u03bb\u03b7\u03bd\u03b9\u03ba\u03ac", english_name="Greek"),
    LocaleInfo(code="en", native_name="English", english_name="English"),
    LocaleInfo(code="es", native_name="Espa\u00f1ol", english_name="Spanish"),
    LocaleInfo(code="fa", native_name="\u0641\u0627\u0631\u0633\u06cc", english_name="Persian"),
    LocaleInfo(code="fi", native_name="Suomi", english_name="Finnish"),
    LocaleInfo(code="fr", native_name="Fran\u00e7ais", english_name="French"),
    LocaleInfo(code="he", native_name="\u05e2\u05d1\u05e8\u05d9\u05ea", english_name="Hebrew"),
    LocaleInfo(code="hi", native_name="\u0939\u093f\u0928\u094d\u0926\u0940", english_name="Hindi"),
    LocaleInfo(code="id", native_name="Bahasa Indonesia", english_name="Indonesian"),
    LocaleInfo(code="it", native_name="Italiano", english_name="Italian"),
    LocaleInfo(code="ja", native_name="\u65e5\u672c\u8a9e", english_name="Japanese"),
    LocaleInfo(code="ko", native_name="\ud55c\uad6d\uc5b4", english_name="Korean"),
    LocaleInfo(code="ms", native_name="Bahasa Melayu", english_name="Malay"),
    LocaleInfo(code="nl", native_name="Nederlands", english_name="Dutch"),
    LocaleInfo(code="no", native_name="Norsk", english_name="Norwegian"),
    LocaleInfo(code="pl", native_name="Polski", english_name="Polish"),
    LocaleInfo(code="pt", native_name="Portugu\u00eas", english_name="Portuguese"),
    LocaleInfo(code="ro", native_name="Rom\u00e2n\u0103", english_name="Romanian"),
    LocaleInfo(code="sv", native_name="Svenska", english_name="Swedish"),
    LocaleInfo(code="th", native_name="\u0e44\u0e17\u0e22", english_name="Thai"),
    LocaleInfo(code="tr", native_name="T\u00fcrk\u00e7e", english_name="Turkish"),
    LocaleInfo(code="uk", native_name="\u0423\u043a\u0440\u0430\u0457\u043d\u0441\u044c\u043a\u0430", english_name="Ukrainian"),
    LocaleInfo(code="vi", native_name="Ti\u1ebfng Vi\u1ec7t", english_name="Vietnamese"),
    LocaleInfo(code="zh", native_name="\u4e2d\u6587", english_name="Chinese"),
)
"""A row per supported language, in the registry's order."""
