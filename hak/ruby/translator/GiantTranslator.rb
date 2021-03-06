class GiantTranslator < Translator
  protected
    def get_subc
      return {
          "a" => "a",
          "b" => "du",
          "c" => "ce",
          "d" => "de",
          "e" => "e",
          "f" => "fi",
          "g" => "gu",
          "h" => "vo",
          "i" => "a",
          "j" => "ar",
          "k" => "go",
          "l" => "n",
          "m" => "l",
          "n" => "r",
          "o" => "ur",
          "p" => "rh",
          "q" => "k",
          "r" => "ja",
          "s" => "th",
          "t" => "o",
          "u" => "un",
          "v" => "ha",
          "w" => "har",
          "x" => "u",
          "y" => "g",
          "z" => "j"
      }
    end

    def word(s)
    	subs = {
    		"ability" => "kr'aff",
    		"abilities" => "kr'affen",
    		"able" => "kun'ah",
    		"above" => "glang",
    		"access" => "til'gah",
    		"accompany" => "folja",
    		"active" => "aktiv",
    		"adamantine" => "kruf'jearn",
    		"adamantium" => "kruf'jearnum",
    		"admit" => "erkan",
    		"adult" => "vux",
    		"advice" => "rad",
    		"afford" => "kostn",
    		"afraid" => "radd",
    		"after" => "eft'r",
    		"age" => "alder", 		
		   	"ale" => "engel",
		   	"almost" => "nastin",
		   	"always" => "alltih'd",
		   	"am" => "ar",
		   	"anger" => "il'sku",
		   	"angry" => "el'skus",
		   	"ancestry" => "linje",
		   	"ancestors of stone" => "linjenstein",
		   	"armor" => "harbunad",
		   	"arrow" => "pil",
		   	"arrows" => "pilen",
		   	"art" => "kunst",
	    	"attack" => "anfal",
	    	"attacking" => "anfel ",
	    	"axe" => "oks",
	    	"axes" => "oksen",
	    	"back" => "bak",
	    	"bake" => "ba'ka",
	    	"baking" => "ba'ken",
	    	"battle" => "slag",
	    	"battles" => "slagen",
	    	"be" => "tun",
	    	"bear" => "bjurn",
	    	"bears" => "bjurnen",
	    	"beard" => "skagg",   	
	    	"bed" => "seng",
	    	"beds" => "sengen",
	    	"bedroom" => "sengrom",
	    	"beholder" => "oga'varls",
	    	"beholders" => "oga'varlsen",
	    	"belief" => "tro'th",
	    	"below" => "under",
	    	"beneath" => "unter",
	    	"bend" => "boja",
	    	"big" => "grov",
	    	"birth" => "byrd",
	    	"black" => "sort",
	    	"blue" => "bla",
	    	"blade" => "blad",
	    	"blades" => "bladen",
	    	"blood" => "blod",
	    	"bow" => "boye",
	    	"book" => "bok",
	    	"books" => "boken",
	    	"brave" => "praktig",
	    	"bravery" => "prakt",
	    	"brother" => "bror",
	    	"brothers" => "broren",
	    	"bye" => "farvel",
	    	"can" => "ka",
	    	"cave" => "grott",
	    	"caves" => "grottum",
	    	"castle" => "festing",
	    	"castles" => "festingen",
	    	"chamber" => "rum",
	    	"chambers" => "rums",
	    	"chieftain" => "forer",
	    	"cloak" => "kappe",
	    	"cloud" => "skye",
	    	"club" => "klub",
	    	"clubs" => "klubet",
	    	"coal" => "sort'jaern",
	    	"coals" => "sort'jaernen",
	    	"cold" => "kalt",
	    	"copper" => "blodbok",
	    	"cow" => "kue",
	    	"cows" => "kuen",
	    	"creature" => "kretur",
	    	"creatures" => "kreturen",
	    	"cutter" => "gravr",
	    	"cycle" => "dyg'n",
	    	"cycles" => "dyg'nen",
	    	"dark" => "murk",
	    	"danger" => "fare",
	    	"dangers" => "faren",
	    	"death" => "dod",
	    	"deaths" => "doden",
	    	"defeat" => "overin",
	    	"defeated" => "overinad",
	    	"defend" => "forvar",
	    	"dishonorable" => "maug",
	    	"dispute" => "drofte",
	    	"divine" => "mazin",
	    	"divine magic" => "mazinmagisk",
	    	"divine magics" => "mazinmagisken",
	    	"dragon" => "wyrm",
	    	"dragons" => "wyrmen",
	    	"drow" => "sort'alv",
	    	"drows" => "sort'alven",
	    	"duergar" => "sort'dverg",
	    	"duergars" => "sort'dvergen",
	    	"dungeon" => "hala",
	    	"dungeons" => "halum",
	    	"dumb" => "duum",
	    	"dwarf" => "dverg",
	    	"dwarves" => "dverger",
	    	"eat" => "aeta",
	    	"eats" => "aetan",
	    	"eating" => "aetum",
	    	"eight" => "att",
	    	"element" => "element",
	    	"elemental" => "element'varls",
	    	"elementals" => "element'varlsen",
	    	"elf" => "alv",
	    	"elves" => "alven",
	    	"enemy" => "uven",
	    	"enemies" => "uvenen",	
	    	"evil" => "maug",
	    	"eye" => "oga",
	    	"eyes" => "ogaen",
	    	"family" => "huslyd",
	    	"far" => "lang",
			"father" => "far",
	    	"fear" => "otte",
	    	"feast" => "fust",
	    	"feasts" => "fusten",
	    	"fire" => "ild",
	    	"fires" => "ilden",
	    	"five" => "fem",
	    	"friend" => "venn",
	    	"friends" => "vennen",
	    	"fog" => "skod",
	    	"food" => "fode",
	    	"foods" => "foden",
	    	"fool" => "tosk",
	    	"fools" => "tosken",
	    	"forge" => "esse",
			"forges" => "essen",
			"foundry" => "gjut'esse",
	    	"fortress" => "festing",
	    	"four" => "fir",
	    	"garbage" => "garasje",
	    	"giant" => "jotun",
	    	"giants" => "jotunen",
	    	"gift" => "gave",
	    	"give" => "gi",
	    	"gnoll" => "best",
	    	"gnolls" => "besten",
	    	"gnome" => "il'fode",
	    	"gnomes" => "il'foden",
	    	"go" => "fer",
	    	"goblin" => "grun'alv",
	    	"goblins" => "grun'alven",
	    	"god" => "gud",
	    	"gold" => "gult",
	    	"golds" => "gulten",
	    	"golem" => "golem",
	    	"golems" => "golems",
	    	"good" => "maat",
	    	"goodbye" => "farvel",
	    	"green" => "grun",
	    	"greetings" => "helsingen",
	    	"great" => "maat'um",
	    	"guard" => "vakt",
	    	"guards" => "vakten",
	    	"guarding" => "vaktum",
	    	"halfling" => "fode",
	    	"halflings" => "foden",
	    	"have" => "ha",
	    	"he" => "han",
	    	"hail" => "helsingen",
	    	"heart" => "hjerte",
	    	"hello" => "helsingen",
	    	"helmet" => "hjelm",
	    	"helmets" => "hjelmen",
	    	"her" => "hon",
	    	"here" => "her",
	    	"high priest" => "stormazin",
	    	"high priestess" => "stormazin'der",
	    	"hill" => "haug",
	    	"hills" => "haugen",
	    	"hill giant" => "haugjotun",
	    	"hill giants" => "haugjotunen",
	    	"him" => "han",
	    	"hobgoblin" => "grov'alv",
	    	"hobgoblins" => "grov'alven",
	    	"holy" => "hellig",
	    	"home" => "heim",
	    	"honor" => "paart",
	    	"horse" => "hest",
	    	"horses" => "hesten",
	    	"hot" => "het",
	    	"hour" => "tid",
	    	"human" => "van",
	    	"humans" => "vanen",
	    	"hundred" => "hund",
	    	"hunt" => "jakt",
			"hunts" => "jaegar",
			"hunting" => "er jaegar",
			"hunted" => "jaegat",
			"hunter" => "jaegar",
			"hunters" => "jaegaren",
			"hurl" => "kast",
			"hurls" => "kastiil",
			"i" => "am",
			"ice" => "ise",
			"illithid" => "hjaern'aeta",
			"illithids" => "hjaern'aetaum",
			"imp" => "imp",
			"imps" => "impen",
			"improve" => "for'beter",
			"improved" => "for'betra",
			"improving" => "for'betrig",
			"intruder" => "ubuden",
			"intruders" => "ubudeg",
			"i'm" => "am'r",
        	"i've" => "am'a",
        	"i'll" => "am'vil",
        	"increase" => "oka",
			"increased" => "okad",
			"increaser" => "oker",
			"increasing" => "okerin",
			"ingot" => "tacka",
			"ingots" => "tackaen",
			"inn" => "vaerdheim",
			"infernal" => "djavul",
			"infernally" => "djavulsk",
			"infernalist" => "djavul'im",
			"infernalists" => "djavul'ist",
			"inside" => "inu'ti",
			"inspiration" => "praegel",
			"inspired" => "pgaeglig",
			"inspire" => "praeg",
			"inspiring" => "praege'lik",
			"institute" => "arran",
			"instrument" => "verk'tyg",
			"insult" => "skymf",
			"insults" => "skymfs",
			"insulting" => "skymmer",
			"insulted" => "skymd",
			"intelligence" => "hjern",
			"intelligent" => "hjernt",
			"intercept" => "for'vred",
			"intercepted" => "for'vreda",
			"intercepts" => "for'vreding",
			"intercepting" => "for'vredum",
			"interfere" => "bryta",
			"interferes" => "bryter",
			"interfered" => "brot",
			"interfering" => "brutum",
			"interest" => "ansprak",
			"interests" => "anspraks",
			"interested" => "unsprak",
			"interesting" => "unspraker",
			"interestingly" => "ansprak nog",
			"interrogate" => "haera",
			"interrogated" => "hort",
			"interrogates" => "haeraem",
			"interrogator" => "hoer'um",
			"interrogating" => "haera nu",
			"intimidate" => "vrede",
			"intimidated" => "vredum",
			"intimidates" => "vredar",
			"intimidating" => "ilsk",
	      	"into" => "ini",
			"invisible" => "syns'ick",
			"iron" => "jaern",
			"is" => "er",
			"it" => "den",
			"jab" => "sla",
			"jabs" => "slaar",
			"jarl" => "jarl",
			"javelin" => "spjut",
			"javelins" => "spjuten",
			"jester" => "narr",
			"jesters" => "narrem",
			"joke" => "vits",
			"jokes" => "vitser",
			"joking" => "vitsar",
			"joker" => "tolp",
			"jokers" => "tolpem",
	      	"join" => "fer mit",
			"joins" => "fer mitem",
			"joined" => "ferum",
			"joining" => "ferim",
			"journey" => "ferd",
			"king" => "kong",
			"kingdom" => "kongerike",
			"key" => "nyk",
			"keys" => "nyksem",
			"keen" => "glud",
			"kidnap" => "tager'im",
			"kill" => "dod",
			"kills" => "dodim",
			"kneel" => "boj",
			"kneels" => "bojum",
			"knife" => "kniv",
			"knives" => "knivum",
			"know" => "veter",
			"knowing" => "veter alt",
			"knows" => "veterum",
			"knowledge" => "insikt",
			"kobold" => "odler",
			"kobolds" => "odlum",
			"law" => "lag",
			"lead" => "fang",
	    	"leader" => "forer",
	    	"lineage" => "linje",
	    	"life" => "liv",
	    	"light" => "stig",
	    	"learn" => "zhaun",
			"left" => "venter",
			"leg" => "bon",
			"legs" => "bons",
			"less" => "min",
			"lesser" => "min're",
			"lessers" => "min'rem",
			"lesson" => "lerd",
			"lessons" => "lerdum",
			"lens" => "bage",
			"level" => "rika",
			"lich" => "dod kong",
			"liches" => "dod kongen",
			"mace" => "spik'klubb",
			"maces" => "spik'klubbem",
			"mage" => "magere",
			"mages" => "magerum",
			"magi" => "magiker",
			"magic" => "magil",
			"magical" => "magisk",
			"mail" => "brynjum",
			"make" => "gor",
			"makes" => "gorul",
			"master" => "storkokk",
			"many" => "mang",
			"material" => "stoff",
			"materials" => "stoffum",
			"me" => "meg",
			"meat" => "kjott",
			"mettle" => "tapperhot",
			"message" => "bud",
			"messaged" => "bud'ad",
			"messages" => "buds",
			"messenger" => "bud'baer",
			"messengers" => "bud'baerum",
			"metal" => "jaern",
			"metals" => "jaernum",
			"meet" => "mot",
			"meeting" => "motuv",
			"memory" => "hjaern'magi",
			"might" => "kruf",
	      	"mighty" => "krufter",
			"military" => "krigs",
			"militarily" => "krigz",
			"militaries" => "krigz'um",
	      	"mine" => "grott'jaern",
			"mines" => "grott'jaernum",
			"mining" => "grott'jaern skul",
			"mined" => "grott'jaerned",
			"mind" => "hjaern",
			"mind flayer" => "hjaern'aeta",
			"mind flayers" => "hjaern'aetaum",	
			"minute" => "minutt",
			"mist" => "dim",
			"mists" => "dimum",
			"monster" => "varls",
			"monsters" => "varlsen",
			"money" => "mynt",
			"mountain" => "fjell",
			"mother" => "hild",
			"my" => "meg",
			"name" => "nom",
			"named" => "nomer",
			"names" => "nomum",
			"naming" => "nomin",
			"near" => "nar",
			"necromancer" => "dod'magi",
			"necromancers" => "dod'magerum",
			"never" => "nag",
			"nine" => "ni",
			"not" => "int",
			"nothing" => "nul",
			"north" => "nor",
			"nown" => "nede",
			"often" => "oft",
			"ogre" => "trollotun",
			"ogres" => "trollotunen",
			"old" => "alder",
			"on" => "pa",
			"onto" => "ove'pa",
			"opening" => "opet",
			"opponent" => "motsan",
			"oppose" => "motsa",
			"opposing" => "motsum",
			"one" => "et",
			"or" => "irer",
			"orb" => "runt",
			"orbs" => "runter",
			"order" => "ord'ig",
			"other" => "ander",
			"orc" => "ork",
			"orcs" => "orken",
			"orog" => "krufter'ork",
			"orogs" => "krufter'orken",
			"our" => "var",
			"ourselves" => "os",
			"ours" => "vaer",
			"outcast" => "svun",
			"outside" => "ut",
			"over" => "of",
			"pact" => "pakt",
			"pain" => "smaert",
			"pains" => "smaerts",
			"painful" => "smaertiv",
			"painfully" => "grov'smaertiv",
			"patrol" => "vakt",
			"patrolling" => "vaktiv",
			"patrols" => "vaktum",
			"patrolled" => "vaktor",
			"platinum" => "platina",
			"platemail" => "grov'brynjum",
			"prevail" => "vin",
			"priest" => "mazin",
			"prison" => "fang",
			"prisoner" => "fanger",
			"portal" => "grint",
			"portals" => "grinten",
			"quality" => "kvalt",
			"qualities" => "kvalter",
			"qualified" => "kval",
			"qualifying" => "kvalum",
			"quarterstaff" => "pin",
			"quarterstaffs" => "pinum",
			"quarterstaves" => "pinum",
			"queen" => "drott",
			"queens" => "drotten",
			"quest" => "mal",
			"quests" => "mal'um",
			"questing" => "maler",
			"question" => "frug",
			"questioned" => "fruger",
			"questioner" => "frugum",
			"questions" => "frugs",
			"questioning" => "frugel",
			"queller" => "rever",	
			"raid" => "raed",
			"range" => "ra'vid",
			"rank" => "rad",
			"red" => "rod",
			"revenge" => "haemnd",
			"reward" => "pr'i",
			"rewards" => "pr'is",
			"rewarded" => "gedev",
			"rewarding" => "geduv",
			"rich" => "rik",
			"riches" => "rikdom",
			"river" => "flod",
			"road" => "vaag",
			"roads" => "vaagen",
			"rothe" => "sort'kue",
			"rothes" => "sort'kuen",
			"room" => "rum",
			"rooms" => "rums",
			"ruby" => "sma'grad",
			"rubies" => "sma'grader",
        	"ruler" => "leder",
        	"rain" => "regun",
        	"rains" => "regunen",
        	"ran" => "sprung'il",
        	"run" => "sprung",
        	"runs" => "sprungel",
			"ruse" => "fall",
			"rune" => "skilt",
			"runes" => "skilter",
			"rune cutter" => "skiltgravr",
			"rune cutters" => "skiltgravr",
			"runt" => "ettin",
			"runts" => "ettinum",
			"sacred" => "hellig",
			"safe" => "saker",
			"safety" => "saker'im",
			"saga" => "sal",
			"second" => "stot",
			"seconds" => "stots",
			"seven" => "sju",
			"she" => "hon",
			"shaman" => "magi",
			"shamans" => "magien",
			"shield" => "skold",
			"shields" => "skolder",
			"sister" => "soster",
			"six" => "sek",
			"silver" => "solv",
			"silvers" => "solven",
			"simple" => "let",
			"simply" => "let'nug",
			"skeleton" => "dod'skel",
			"skeletal" => "dod'skela",
			"skeletons" => "dod'skelen",
			"small" => "lit'e",
			"smart" => "grov'hjaern",
			"smith" => "smed",
			"smiths" => "smeda",
			"smithy" => "smedil",
			"sound" => "ljut",
			"sounds" => "ljutum",
			"sounding" => "ljuter",
			"sounded" => "lat",
			"south" => "sytt",
			"southern" => "sytter",
			"spear" => "spyd",
			"spears" => "spyds",
			"spells" => "magis",
			"spellbook" => "magi'bok",
			"spellbooks" => "magi'boken",
			"spider" => "vid'under",
			"spiders" => "vid'underen",
			"spike" => "spik",
			"spikes" => "spiken",
			"strong" => "krufter",
	      	"stronger" => "krufter'starken",
	    	"stone" => "stein",
	    	"stones" => "steinen",
	    	"storm" => "uvar",
	    	"storms" => "uvarum",
	    	"storm giant" => "uvarjotun",
	    	"story" => "sal",
	    	"stories" => "saleg",
	    	"stupid" => "duum",
	    	"surprise" => "forbaus",
	    	"sword" => "sverd",
	    	"swords" => "sverds",
	    	"take" => "fange",
	    	"teeth" => "tenner",
	    	"temple" => "bapart",
	    	"ten" => "tier",
	    	"they" => "de",
	    	"them" => "dum",
	    	"thief" => "tuv",
	    	"thieves" => "tuvum",
	    	"thought" => "tanke",
	    	"thousand" => "tusen",
	    	"three" => "tre",
	    	"titan" => "vonin",
	    	"titans" => "voninen",
	    	"trail" => "treke",
	    	"trails" => "treken",
	    	"treasure" => "skat",
	    	"treasures" => "skat'en",
	    	"treaty" => "traktat",
	    	"tribal leader" => "jarl",
	    	"tribe" => "stomm",
	    	"truth" => "trut",
	    	"troll" => "troll",
	    	"trolls" => "trollen",
	   		"to" => "zo",
	   		"too" => "foor",
	   		"tomb" => "grav",
	   		"tombs" => "graven",	
	    	"two" => "to",
	    	"under" => "under",
	    	"underdark" => "under'murk",
	    	"unknown" => "okand",
			"until" => "til",
			"undead" => "odod",
			"undeath" => "odod",
			"up" => "opp",
			"vaprak" => "vaprak",
			"vaprak's" => "vaprak's",
			"vampire"  => "blodsu'g",
			"vampires"  => "blodsu'gen",
			"victory" => "seir",
			"water" => "vat'in",
			"waters" => "vat'inum",
			"war" => "krig",
			"wars" => "krigen",
			"warm" => "varm",
			"warlock" => "weirdner",
			"warlocks" => "weirdneren",
			"warrior" => "krigga",
			"warriors" => "kriggaen",
			"weather" => "vaer",
			"weird" => "weirdner",
			"west" => "vest",
			"what" => "vha",
			"white" => "kvit",
			"will" => "vil",
			"wills" => "vils",
			"who" => "wer",
			"where" => "wie",
			"what" => "wo",
			"wish" => "onsk",
			"wishes" => "onskun",
			"wind" => "vind",
			"witch" => "hexa",
			"witches" => "hexenen",
			"wizard" => "weirdner",
			"wizards" => "weirdneren",
			"would" => "sku'g",
			"you" => "du",
        	"your" => "di",
        	"yours" => "di",
        	"yourself" => "di'salv",
        	"yourselves" => "di'salven",
    	}

      # Find out whether the string is Upperfirst, UPPERCASE or lowercase. Assume
      # lowercase if not Upperfirst or UPPERCASE for simplicity and to promote good
      # grammar.
      cap = :lc
      if s.eql?(s.capitalize)
        cap = :ucfirst
      elsif s.eql?(s.upcase)
        cap = :uc
      end

      d = s.downcase

      # Do the actual substitution.
      x = subs[d]

      if x == nil
        # Try expanding some contractions.
        if d[-3,3] == "n't"
          return word(s[0,s.size - 3]) + " " + word("not")
        elsif d[-3,3] == "'ll"
          return word(s[0,s.size - 3]) + " " + word("will")
        elsif d[-3,3] == "'ve"
          return word(s[0,s.size - 3]) + " " + word("have")
        elsif d[-2,2] == "'d"
          return word(s[0,s.size - 2]) + " " + word("would")
        elsif d[-2,2] == "'s"
          return word(s[0,s.size - 2]) + "'s"
        end
      end

      # If word could not be translated, fall back on substitution. Otherwise,
      # fix case.
      if x == nil
        return super(s)
      else
        case cap
          when :uc then x.upcase!
          when :ucfirst then x.capitalize!
        end
        return x
      end
    end
 
    def colour
      return "\x8d\xab\xc1"
    end
end
