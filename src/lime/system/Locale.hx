package lime.system;

/**
	A locale, made of a language code and a country (region) code.

	`System.getPreferredLocales()` returns the user's locales, in order of preference.
	`currentLocale`, `systemLocale`, `region` and the string constructor are kept from
	Codename Engine's lime; unlike there, `Locale` is a class, so use `toString()` and
	`new Locale("en-US")` instead of converting to and from `String` implicitly.
**/
class Locale
{
	/**
		The locale the application uses. Defaults to `systemLocale` (Codename Engine API).
	**/
	public static var currentLocale(get, set):Locale;

	/**
		The user's preferred locale, or `en-US` if it is unknown (Codename Engine API).
	**/
	public static var systemLocale(get, never):Locale;

	@:noCompletion private static var __currentLocale:Locale;
	@:noCompletion private static var __systemLocale:Locale;

	/**
		The language code, like `en`.
	**/
	public var language:String;

	/**
		The country code, like `US`.
	**/
	public var country:String;

	/**
		Same as `country` (Codename Engine API).
	**/
	public var region(get, never):String;

	/**
		@param value  Optional locale string to parse, like `en-US`, `en_US` or `en_US.UTF-8`.
	**/
	public function new(?value:String)
	{
		if (value == null)
			return;

		final dot = value.indexOf(".");
		if (dot > -1)
			value = value.substring(0, dot);

		var separator = value.indexOf("_");
		final dash = value.indexOf("-");
		if (separator == -1 || (dash > -1 && dash < separator))
			separator = dash;

		if (separator > -1)
		{
			language = value.substring(0, separator);
			country = value.substring(separator + 1);
		}
		else
		{
			language = value;
		}
	}

	/**
		Whether both locales have the same language and region, ignoring case.
	**/
	public function equals(other:Locale):Bool
	{
		if (other == null)
			return false;

		inline function same(a:String, b:String):Bool
			return a == b || (a != null && b != null && a.toLowerCase() == b.toLowerCase());

		return same(language, other.language) && same(country, other.country);
	}

	/**
		The locale as `language-COUNTRY`, like `en-US`.
	**/
	public function toString():String
	{
		return country != null && country.length > 0 ? '$language-$country' : language;
	}

	@:noCompletion private inline function get_region():String
	{
		return country;
	}

	@:noCompletion private static function get_systemLocale():Locale
	{
		if (__systemLocale == null)
		{
			final preferred = System.getPreferredLocales();
			__systemLocale = preferred != null && preferred.length > 0 ? preferred[0] : new Locale("en-US");
		}
		return __systemLocale;
	}

	@:noCompletion private static function get_currentLocale():Locale
	{
		if (__currentLocale == null)
			__currentLocale = get_systemLocale();
		return __currentLocale;
	}

	@:noCompletion private static function set_currentLocale(value:Locale):Locale
	{
		return __currentLocale = value;
	}
}
