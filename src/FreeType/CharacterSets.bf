namespace FreeType;


using System;


static class CharacterSets
{
	/** Numbers from 0 to 9 */
	const public StringView Numbers = "0123456789";

	/** Special symbols */
	const public StringView Symbols = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~";
	
	/** English */
	const public StringView EN = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

	/** French */
	const public StringView FR = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÀÂÇÉÈÊËÎÏÔÙÛÜŸàâçéèêëîïôùûüÿ";

	/** Italian */
	const public StringView IT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÀÈÉÌÎÒÙàèéìîòù";

	/** German */
	const public StringView DE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÄÖÜßäöü";

	/** Spanish */
	const public StringView ES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁÉÍÓÚÜÑáéíóúüñ";

	/** Russian */
	const public StringView RU = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя";

	/** Portuguese */
	const public StringView PT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç";

	/** Polish */
	const public StringView PL = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzĄĆĘŁŃÓŚŹŻąćęłńóśźż";

	/** Turkish */
	const public StringView TR = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÇĞİŞÜÖçğışüö";

	/** Dutch */
	const public StringView NL = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

	/** Greek */
	const public StringView EL = "ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψω";

	/** Hungarian */
	const public StringView HU = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁÉÍÓÖŐÚÜŰáéíóöőúüű";

	/** Czech */
	const public StringView CS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁÉÍÓÚÝČĎĚŇŘŠŤŽáéíóúýčďěňřšťž";

	/** Japanese */
	const public StringView JA = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン";

	/** Korean */
	const public StringView KO = "가각간갇갈갉갊감갑값갓갔강갖갗같갚갛개객걀걋걔걜걧거걱건걷걸걺검겁것겄겅겆겉게겐겔겕겖겗겟겠격겪견겯결겺겻경곁계곈곌곔곕곗고곡곤곧골곪곬곯곰곱곳공곶과관괄괆광괘괜괠괬괭괴괸괼괽괾굉교굔굘구국군굳굴굵굶굷굸굼굽굿궁궂궃궄궈궉권궐궝궠궤궷귀귁귄귄귈귐귑귒귓";

	/** Simplified chinese */
	const public StringView ZHCN = "的一是在不了有和人这中大为上个国我以要他时来用们生到作地于出就分对成会可主发年动同工也能下过子说产种面而方后多定行学法所民得经十三之进着等部度家电力里如水化高自二理起小物现实加量都两体制机当使点从业本去把性好应开它合还因由其些然前外天政四日那社义事平形相全表间样与关各重新线内数正心反你明看原又么利比或但质气第向道命此变条只没结解问意建月公无系军很情者最立代想已通并提直题党程展五果料象员革位入常文总次品式活设及管特件长求老头基资边流路级少图山统接知较将组见计别她手角期根论运农指几九区强放决西被干做必战先回则任取据处队南给色光门即保治北造百规热领七海口东导器压志世金增争济阶油思术极交受联什认六共权收证改清己美再采转更单风切打白教速花带安场身车例真务具万每目至达走积示议声完类红细早听愿量超王毛绿术决传济云飞声且物活必快车备感际放干共达听写造准张候乎";

	/** Traditional chinese */
	const public StringView ZHTW = "的一是在不了有和人這中大為上個國我以要他時來用們生到作地於出就分對成會可主發年動同工也能下過子說產種面而方後多定行學法所民得經十三之進著等部度家電力裡如水化高自二理起小物現實加量都兩體制機當使點從業本去把性好應開它合還因由其些然前外天政四日那社義事平形相全表間樣與關各重新線內數正心反你明看原又麼利比或但質氣第向道命此變條只沒結解問意建月公無系軍很情者最立代想已通並提直題黨程展五果料象員革位入常文總次品式活設及管特件長求老頭基資邊流路級少圖山統接知較將組見計別她手角期根論運農指幾九區強放決西被干做必戰先回則任取據處隊南給色光門即保治北造百規熱領七海口東導器壓志世金增爭濟階油思術極交受聯什認六共權收證改清己美再採轉更單風切打白教速花帶安場身車例真務具萬每目至達走積示議聲完類紅細早聽願量超王毛綠術決傳濟雲飛聲且物活必快車備感際放干共達聽寫造準張候乎";

	/** Finnish */
	const public StringView FI = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÅÄÖåäö";

	/** Swedish */
	const public StringView SV = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÅÄÖåäö";

	/** Danish */
	const public StringView DA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÆØÅæøå";

	/** Norwegian */
	const public StringView NO = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÆØÅæøå";

	/** Thai */
	const public StringView TH = "กขคฃฅฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮ";

	/** Ukrainian */
	const public StringView UK = "АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯабвгґдеєжзиіїйклмнопрстуфхцчшщьюя";

	/** Vietnamese */
	const public StringView VI = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ";

	/** Hindi */
	const public StringView HI = "अआइईउऊऋएऐओऔकखगघङचछजझञटठडढणतथदधनपफबभमयरलवशषसहक्षत्रज्ञ";
}