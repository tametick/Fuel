package thx.translation;
import thx.culture.Info;
import thx.culture.Culture;
import thx.translation.ITranslation;
import thx.translation.PluralForms;

class EmptyTranslation implements ITranslation
{
	public var domain(getDomain, setDomain) : String;
	var _domain : String;
	
	public function new()
	{
	}

	public function _(id : String, ?domain : String) : String
	{
		return id;
	}
	
	public function __(?ids : String, idp : String, quantifier : Int, ?domain : String) : String
	{
		if (null != ids && quantifier == 1)
			return ids;
		else
			return idp;
	}
	
	function getDomain()
	{
		return null;
	}
	function setDomain(v : String) return v
}