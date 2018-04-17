# PBCore Validator, Validator class
# Copyright © 2009 Roasted Vermicelli, LLC
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'libxml'

# A class to validate PBCore documents.
class Validator
  include LibXML #:nodoc:

  # The PBCore namespace
  PBCORE_NAMESPACE = "http://www.pbcore.org/PBCore/PBCoreNamespace.html"

  # List of supported XSDs
  PBCORE_VERSIONS = {
#    "1.1" => { :version => "PBCore 1.1", :xsd => "PBCoreXSD_Ver_1-1_Final.xsd" },
    "2.1" => { :version => "PBCore 2.1", :xsd => "pbcore-2.1.xsd" },
    "2.0" => { :version => "PBCore 2.0", :xsd => "PBCoreXSD_v2.xsd" },
    "1.2" => { :version => "PBCore 1.2", :xsd => "PBCoreSchema_v1-2.xsd" },
    "1.2.1" => { :version => "PBCore 1.2.1", :xsd => "PBCoreXSD_Ver_1-2-1.xsd" },
    "1.3" => { :version => "PBCore 1.3", :xsd => "PBCoreXSD-v1.3.xsd" }
  }.freeze

  # A set of predefined value lists, which are recommended in various circumstances.
  module Picklists
    TITLE_TYPES = [
      "Package", "Project", "Collection", "Series", "Episode", "Program",
      "Segment", "Clip", "Scene", "Shot", "Selection or Excerpt", "Alternative",
      "Caption File", "Descriptive Audio", "Transcript File", "Music",
      "Nature/ambient sound", "Song", "Voice", "Art Work", "Chart", "Diagram",
      "Drawing", "Graphic", "Map", "Model", "Photograph", "Picture", "Postcard",
      "Poster", "Courseware Class", "Courseware Module", "Drill and Practice",
      "Game", "Model Building", "Quiz", "Reflection Activity", "Role Play",
      "Self Assessment", "Simulation", "Test", "Web page/site",
      "Linear Presentation", "Multimedia Presentation", "Slide Show",
      "Traditional Academic Poster", "Electronic Academic Poster",
      "Kiosk Event", "Syllabus", "Lesson Plan", "Study Guide",
      "Teacher's Guide", "Article", "Book", "Chapter", "Issue", "Lyrics",
      "Manuscript", "Periodical", "Score", "Abridged Version", "Air Version",
      "Captioned Version", "Cell Phone Version", "Full Version", "iPod Version",
      "Packaging Version", "Pledge Version", "Published Version", "Re-Title",
      "Web Version", "Working Title", "Other"]

    DESCRIPTION_TYPES = [
     "Abstract", "Package", "Project", "Collection", "Series", "Episode",
     "Program", "Segment", "Clip", "Selection or Excerpt", "Table of Contents",
     "Segment Sequence", "Rundown", "Playlist", "Script", "Transcript",
     "Descriptive Audio", "PODS", "PSD", "Anecdotal Comments & Reflections",
     "Listing Services", "Content Flags", "Other"
    ]

    RELATION_TYPES = [
     "Has Format", "Is Format Of", "Has Part", "Is Part Of", "Has Version",
     "Is Version Of", "References", "Is Referenced By", "Replaces",
     "Is Replaced By", "Requires", "Is Required By", "Other"
    ]

    AUDIENCE_LEVELS = [
     "K-12 (general)", "Pre-school (kindergarten)", "Primary (grades 1-6)",
     "Intermediate (grades 7-9)", "High School (grades 10-12)", "College",
     "Post Graduate", "General Education", "Educator", "Vocational", "Adult",
     "Special Audiences", "General", "Male", "Female", "Other"
    ]

    AUDIENCE_RATINGS = [
     "E", "TV-Y", "TV-Y7", "TV-Y7-FV", "TV-G", "TV-PG", "TV-PG+VSLD",
     "TV-PG+VSL", "TV-PG+VSD", "TV-PG+VS", "TV-PG+VLD", "TV-PG+VL",
     "TV-PG+VD", "TV-PG+V", "TV-PG+SLD", "TV-PG+SL", "TV-PG+SD", "TV-PG+S",
     "TV-PG+LD", "TV-PG+L", "TV-PG+D", "TV-14", "TV-14+VSLD", "TV-14+VSL",
     "TV-14+VSD", "TV-14+VS", "TV-14+VLD", "TV-14+VL", "TV-14+VD", "TV-14+V",
     "TV-14+SLD", "TV-14+SL", "TV-14+SD", "TV-14+S", "TV-14+LD", "TV-14+L",
     "TV-14+D", "TV-MA", "TV-MA+VSL", "TV-MA+VS", "TV-MA+VL", "TV-MA+V",
     "TV-MA+SL", "TV-MA+S", "TV-MA+L", "MPAA: G", "MPAA: PG", "MPAA: PG-13",
     "MPAA: R", "MPAA: NC-17", "MPAA: NR"
    ]

    CREATOR_ROLES = [
     "Artist", "Associate Producer", "Cinematographer", "Composer",
     "Co-Producer", "Creator", "Director", "Editor", "Essayist",
     "Executive Producer", "Host", "Illustrator", "Interviewer", "Moderator",
     "Photographer", "Producer", "Production Unit", "Reporter", "Writer",
     "Other"
    ]

    CONTRIBUTOR_ROLES = [
     "Actor", "Advisor", "Anchor", "Arranger", "Artist", "Assistant Cameraman",
     "Assistant Director", "Assistant Editor", "Assistant Producer - Film",
     "Assistant Researcher", "Assistant Stage Manager",
     "Assistant to the Producer", "Assistant Unit Manager",
     "Associate Director", "Associate Producer", "Audio", "Audio Assistant",
     "Audio Editor", "Audio Engineer", "Audio Mixer", "Author",
     "Boom Operator", "Camera Assistant", "Cameraperson", "Casting",
     "Chief Camera - Segment", "Cinematographer", "Commentary Editor",
     "Commentator", "Community Coordinator", "Composer", "Concept",
     "Conductor", "Contributor", "Co-Producer", "Crane", "Director",
     "Director - Artistic", "Director - Dance", "Director - Doc Material",
     "Director - Segment", "Edit Programmer", "Editor", "Editor - graphics",
     "Editor - Segment", "Engineer", "Essayist", "Executive Producer",
     "Fashion Consultant", "Film Editor", "Film Sound", "Filmmaker",
     "Floor Manager", "Funder", "Gaffer", "Graphic Designer", "Graphics",
     "Guest", "Host", "Illustrator", "Instrumentalist", "Intern",
     "Interpreter", "Interviewee", "Interviewer", "Lecturer", "Lighting",
     "Lighting Assistant", "Lighting Director", "Make-Up",
     "Mobile Unit Supervisor", "Moderator", "Music Assistant",
     "Music Coordinator", "Music Director", "Musical Staging", "Musician",
     "Narrator", "News Director", "Panelist", "Performer", "Performing Group",
     "Photographer", "Post-prod Audio", "Post-prod Supervisor", "Producer",
     "Producer - Segment", "Production Assistant", "Production Manager",
     "Production Personnel", "Production Personnel", "Production Secretary",
     "Production Unit", "Project Director", "Publicist", "Reader",
     "Recording engineer", "Recordist", "Reporter", "Researcher",
     "Scenic Design", "Senior Editor", "Senior Researcher", "Sound",
     "Sound Mixer", "Speaker", "Staff Volunteer", "Stage Manager",
     "Still Photography", "Studio Technician", "Subject", "Switcher",
     "Synthesis", "Synthesis Musician", "Talent Coordinator",
     "Technical Consultant", "Technical Director", "Technical Production",
     "Theme Music", "Titlist", "Translator", "Unit Manager", "Video",
     "Videotape Assembly", "Videotape Editor", "Videotape Engineer",
     "Videotape Recordist", "Vidifont Operator", "Vocalist", "VTR Recordist",
     "Wardrobe", "Writer", "Other"
    ]
    
    COVERAGE_TYPES = [
		'Spatial','Temporal'
	]
    PUBLISHER_ROLES = [
     "Copyright Holder", "Distributor", "Presenter", "Publisher",
     "Release Agent", "Other"
    ]

    PHYSICAL_FORMATS = [
     "Film: 8mm", "Film: 16mm", "Film: 35mm", "Film: 70mm", "8mm video",
     "8mm: Hi8 Video", "8mm: Digital-8", "1/4 inch videotape: Akai",
     "1/2 inch videotape: CV", "1/2 inch videotape: EIAJ Type 1",
     "1/2 inch videotape: VCR", "1/2 inch videotape: V2000",
     "1/2 inch videotape:Hawkeye/Recam/M", "3/4 inch videotape: U-matic",
     "3/4 inch videotape: U-matic SP", "1 inch videotape: PI-3V",
     "1 inch videotape: EV-200", "1 inch videotape: EL3400",
     "1 inch videotape: SMPTE Type A", "1 inch videotape: SMPTE Type B",
     "1 inch videotape: SMPTE Type C", "1 inch videotape: IVC-700/800/900",
     "1 inch videotape: Helical BVH-1000", "2 inch videotape: Quad",
     "2 inch videotape: Helical Ampex VR-1500",
     "2 inch videotape: Sony Helical SV-201",
     "2 inch videotape: Helical IVC-9000", "Betacam", "Betacam SP",
     "Betacam Digital (Digi Beta)", "Betacam SX", "Betamax/Super/HB",
     "DV Mini", "DVC-Pro 25", "DVC-Pro 50", "DVC-Pro 50/P", "DVCam: Sony",
     "D1", "D2", "D3", "D5", "D6", "D7", "HD: D5", "HD: D9", "HD: DVC PRO HD",
     "HDCAM", "VHS", "S-VHS", "W-VHS", "CD-Video", "CD-ROM", "DVD-Video",
     "HD-Videodisc", "BD-Videodisc", "UMD-Videodisc: Sony",
     "EVD-Videodisc: China", "DVD-R", "DVD+R", "DVD-RW", "DVD+RW", "DVD+R DL",
     "Laser Videodisc CAV: 12-inch", "Laser Videodisc CLV: 12-inch",
     "Hard Drive", "Flash Memory", "Cartivision", "CVC", "DCT", "ED-Beta",
     "EIAJ Cartridge", "HDD1000", "HDV1000", "Macthronics MVC-10", "M-II",
     "MPEG IMX", "UniHi", "V-Cord", "V-Cord II", "VTR150", "VTR600", "VX",
     "1/4 inch audio tape", "1/2 inch audio tape", "1/2 inch digital audio",
     "1 inch audio tape", "2 inch audio tape", "Audio cart", "CD-Audio",
     "DVD-Audio", "DARS: DA-88", "DAT", "LP Record", "LP Record (45)",
     "Hard Drive", "Flash Memory", "1/4 inch audio cassette",
     "1/8 inch audio cassette", "8-Track cassette", "Lacquer discs/acetates",
     "Shellac discs", "F1 Beta tape", "DBX 700 VHS tape", "Wire",
     "High 8 - DA78", "Roland DM 80", "Minidisc", "Art original", "Art print",
     "Art reproduction", "Chart", "Filmstrip", "Flash card", "Flip chart",
     "Kodak PhotoCD", "Photograph", "Picture", "Postcard", "Poster",
     "Radiograph", "Slide", "Stereograph", "Study print", "Technical drawing",
     "Transparency", "Wall chart", "Binder", "Book", "Manuscript", "Newspaper",
     "Paper", "Periodical"
    ]

    DIGITAL_FORMATS =     [
     "not specified", "video/3gpp", "video/3gpp2", "video/3gpp-tt",
     "video/BMPEG", "video/BT656", "video/CelB", "video/DV",
     "video/H261", "video/H263", "video/H263-1998", "video/H263-2000",
     "video/H264", "video/JPEG", "video/MJ2", "video/MP1S",
     "video/MP2P", "video/MP2T", "video/mp4", "video/MP4V-ES",
     "video/MPV", "video/mpeg", "video/mpeg4-generic", "video/nv",
     "video/parityfec", "video/pointer", "video/quicktime",
     "video/raw", "video/rtx", "video/SMPTE292M", "video/vc1",
     "video/vnd.dlna.mpeg-tts", "video/vnd.fvt",
     "video/vnd.hns.video", "video/vnd.motorola.video",
     "video/vnd.motorola.videop", "video/vnd.mpegurl",
     "video/vnd.nokia.interleaved-multimedia",
     "video/vnd.nokia.videovoip", "video/vnd.objectvideo",
     "video/vnd.sealed.mpeg1", "video/vnd.sealed.mpeg4",
     "video/vnd.sealed.swf", "video/vnd.sealedmedia.softseal.mov",
     "video/vnd.vivo", "audio/32kadpcm", "audio/3gpp", "audio/3gpp2",
     "audio/ac3", "audio/AMR", "audio/AMR-WB", "audio/amr-wb+",
     "audio/asc", "audio/basic", "audio/BV16", "audio/BV32",
     "audio/clearmode", "audio/CN", "audio/DAT12", "audio/dls",
     "audio/dsr-es201108", "audio/dsr-es202050", "audio/dsr-es202211",
     "audio/dsr-es202212", "audio/eac3", "audio/DVI4", "audio/EVRC",
     "audio/EVRC0", "audio/EVRC1", "audio/EVRCB", "audio/EVRCB0",
     "audio/EVRCB1", "audio/EVRC-QCP", "audio/G722", "audio/G7221",
     "audio/G723", "audio/G726-16", "audio/G726-24", "audio/G726-32",
     "audio/G726-40", "audio/G728", "audio/G729", "audio/G7291",
     "audio/G729D", "audio/G729E", "audio/GSM", "audio/GSM-EFR",
     "audio/iLBC", "audio/L8", "audio/L16", "audio/L20", "audio/L24",
     "audio/LPC", "audio/mobile-xmf", "audio/MPA", "audio/mp4",
     "audio/MP4A-LATM", "audio/mpa-robust", "audio/mpeg",
     "audio/mpeg4-generic", "audio/parityfec", "audio/PCMA",
     "audio/PCMU", "audio/prs.sid", "audio/QCELP", "audio/RED",
     "audio/rtp-midi", "audio/rtx", "audio/SMV", "audio/SMV0",
     "audio/SMV-QCP", "audio/t140c", "audio/t38",
     "audio/telephone-event", "audio/tone", "audio/VDVI",
     "audio/VMR-WB", "audio/vnd.3gpp.iufp", "audio/vnd.4SB",
     "audio/vnd.audiokoz", "audio/vnd.CELP", "audio/vnd.cisco.nse",
     "audio/vnd.cmles.radio-events", "audio/vnd.cns.anp1",
     "audio/vnd.cns.inf1", "audio/vnd.digital-winds",
     "audio/vnd.dlna.adts", "audio/vnd.everad.plj",
     "audio/vnd.hns.audio", "audio/vnd.lucent.voice",
     "audio/vnd.nokia.mobile-xmf", "audio/vnd.nortel.vbk",
     "audio/vnd.nuera.ecelp4800", "audio/vnd.nuera.ecelp7470",
     "audio/vnd.nuera.ecelp9600", "audio/vnd.octel.sbc",
     "audio/vnd.rhetorex.32kadpcm",
     "audio/vnd.sealedmedia.softseal.mpeg", "audio/vnd.vmx.cvsd",
     "image/cgm", "image/fits", "image/g3fax", "image/gif",
     "image/ief", "image/jp2", "image/jpeg", "image/jpm", "image/jpx",
     "image/naplps", "image/png", "image/prs.btif", "image/prs.pti",
     "image/t38", "image/tiff", "image/tiff-fx",
     "image/vnd.adobe.photoshop", "image/vnd.cns.inf2",
     "image/vnd.djvu", "image/vnd.dwg", "image/vnd.dxf",
     "image/vnd.fastbidsheet", "image/vnd.fpx", "image/vnd.fst",
     "image/vnd.fujixerox.edmics-mmr",
     "image/vnd.fujixerox.edmics-rlc", "image/vnd.globalgraphics.pgb",
     "image/vnd.microsoft.icon", "image/vnd.mix", "image/vnd.ms-modi",
     "image/vnd.net-fpx", "image/vnd.sealed.png",
     "image/vnd.sealedmedia.softseal.gif",
     "image/vnd.sealedmedia.softseal.jpg", "image/vnd.svf",
     "image/vnd.wap.wbmp", "image/vnd.xiff", "text/calendar",
     "text/css", "text/csv", "text/directory", "text/dns",
     "text/ecmascript (obsolete)", "text/enriched", "text/html",
     "text/javascript (obsolete)", "text/parityfec", "text/plain",
     "text/prs.fallenstein.rst", "text/prs.lines.tag", "text/RED",
     "text/rfc822-headers", "text/richtext", "text/rtf", "text/rtx",
     "text/sgml", "text/t140", "text/tab-separated-values",
     "text/troff", "text/uri-list", "text/vnd.abc", "text/vnd.curl",
     "text/vnd.DMClientScript", "text/vnd.esmertec.theme-descriptor",
     "text/vnd.fly", "text/vnd.fmi.flexstor", "text/vnd.in3d.3dml",
     "text/vnd.in3d.spot", "text/vnd.IPTC.NewsML",
     "text/vnd.IPTC.NITF", "text/vnd.latex-z",
     "text/vnd.motorola.reflex", "text/vnd.ms-mediapackage",
     "text/vnd.net2phone.commcenter.command",
     "text/vnd.sun.j2me.app-descriptor",
     "text/vnd.trolltech.linguist", "text/vnd.wap.si",
     "text/vnd.wap.sl", "text/vnd.wap.wml", "text/vnd.wap.wmlscript",
     "text/xml", "text/xml-external-parsed-entity",
     "application/http", "application/hyperstudio",
     "application/javascript", "application/mac-binhex40",
     "application/marc", "application/mbox",
     "application/mediaservercontrol+xml", "application/mp4",
     "application/mpeg4-generic", "application/mpeg4-iod",
     "application/mpeg4-iod-xmt", "application/msword",
     "application/mxf", "application/pdf", "application/postscript",
     "application/rdf+xml", "application/rtf", "application/rtx",
     "application/sgml", "application/sgml-open-catalog",
     "application/smil (OBSOLETE)", "application/smil+xml",
     "application/soap+fastinfoset", "application/soap+xml",
     "application/ssml+xml", "application/vnd.adobe.xfdf",
     "application/vnd.apple.installer+xml",
     "application/vnd.framemaker",
     "application/vnd.google-earth.kml+xml",
     "application/vnd.google-earth.kmz",
     "application/vnd.HandHeld-Entertainment+xml",
     "application/vnd.lotus-1-2-3", "application/vnd.lotus-approach",
     "application/vnd.lotus-freelance", "application/vnd.lotus-notes",
     "application/vnd.lotus-organizer",
     "application/vnd.lotus-screencam",
     "application/vnd.lotus-wordpro",
     "application/vnd.mozilla.xul+xml", "application/vnd.ms-artgalry",
     "application/vnd.ms-asf", "application/vnd.ms-cab-compressed",
     "application/vnd.mseq", "application/vnd.ms-excel",
     "application/vnd.ms-fontobject", "application/vnd.ms-htmlhelp",
     "application/vnd.msign", "application/vnd.ms-ims",
     "application/vnd.ms-lrm", "application/vnd.ms-powerpoint",
     "application/vnd.ms-project", "application/vnd.ms-tnef",
     "application/vnd.ms-wmdrm.lic-chlg-req",
     "application/vnd.ms-wmdrm.lic-resp",
     "application/vnd.ms-wmdrm.meter-chlg-req",
     "application/vnd.ms-wmdrm.meter-resp",
     "application/vnd.ms-works", "application/vnd.ms-wpl",
     "application/vnd.ms-xpsdocument", "application/vnd.palm",
     "application/vnd.paos.xml", "application/vnd.Quark.QuarkXPress",
     "application/vnd.visio", "application/vnd.wordperfect",
     "application/wordperfect5.1", "application/xhtml+xml",
     "application/xml", "application/xml-dtd",
     "application/xml-external-parsed-entity", "application/zip"
    ]

    MEDIA_TYPES = [
     "Animation", "Artifact", "Collection", "Dataset", "Event",
     "Interactive Resource", "Moving Image", "Physical Object", "Presentation",
     "Service", "Software", "Sound", "Static Image", "Text"
    ]
    
    INSTANTIATION_MEDIA_TYPES = [ 
		'Moving Image', 'Audio'
	]

    GENERATIONS = [
     "Artifact/Award", "Artifact/Book", "Artifact/Costume",
     "Artifact/Merchandise", "Artifact/Optical disk reader",
     "Artifact/SCSI Hard Drive", "Artifact/Sy-Quest drive", "Audio/Air track",
     "Audio/Audio dub", "Audio/Audio master (full mix)", "Audio/Master mix",
     "Audio/Mix element", "Audio/Music", "Audio/Narration",
     "Audio/Optical track", "Audio/Original recording",
     "Audio/Radio program (Dub)", "Audio/Radio program (Master)",
     "Audio/Sound effects", "Audio/Transcription dub",
     "Container/Backup (computer files)", "Container/Sy-Quest Install Disks",
     "Moving image/Air print", "Moving image/Answer print",
     "Moving image/Backup master", "Moving image/Backup master",
     "Moving image/BW internegative", "Moving image/BW kinescope negative",
     "Moving image/BW workprint", "Moving image/Clip reel",
     "Moving image/Color edited workprint",
     "Moving image/Color internegative (CRI)", "Moving image/Color master",
     "Moving image/Color workprint", "Moving image/Distribution dub",
     "Moving image/Doc only dub", "Moving image/Doc only master",
     "Moving image/Graphics - animation", "Moving image/Green Label Master",
     "Moving image/Incomplete master", "Moving image/International master",
     "Moving image/Interpositive", "Moving image/ISO reel",
     "Moving image/Line reel", "Moving image/Master",
     "Moving image/Mixed magnetic track", "Moving image/News tape",
     "Moving image/Open - Close", "Moving image/Orig BW a & b negative",
     "Moving image/Orig BW negative", "Moving image/Orig color a & b negative",
     "Moving image/Orig color a & b reversal",
     "Moving image/Orig color negative", "Moving image/Original",
     "Moving image/Original footage", "Moving image/PBS backup",
     "Moving image/PBS dub", "Moving image/PBS master",
     "Moving image/Preservation master", "Moving image/Promo",
     "Moving image/Protection master", "Moving image/Release print",
     "Moving image/Screening tapee", "Moving image/Stock footage",
     "Moving image/Submaster", "Moving image/Sync pix and sound",
     "Moving image/Tease", "Moving image/Viewing copy",
     "Moving image/Work print", "Static image/Autochrome",
     "Static image/Caricature", "Static image/Carte de viste",
     "Static image/Color print", "Static image/Contact sheet",
     "Static image/Daguerrotype", "Static image/Digital file",
     "Static image/Drawing", "Static image/Engraving",
     "Static image/Glass negative", "Static image/Glass slide",
     "Static image/Illustration", "Static image/Lithograph",
     "Static image/Map", "Static image/Nitrate negative",
     "Static image/Other (see note)", "Static image/Painting",
     "Static image/Photo research file", "Static image/Photocopy",
     "Static image/Photograph", "Static image/Postcard", "Static image/Print",
     "Static image/Slide", "Static image/Stereoview", "Static image/Still",
     "Static image/Transparency", "Static image/Woodcut",
     "Text/Accounting statements", "Text/Budget file", "Text/Caption file",
     "Text/Contracts", "Text/Correspondence", "Text/Credit list",
     "Text/Crew list", "Text/Cue sheet", "Text/Documentation", "Text/EDL",
     "Text/Educational Material", "Text/Invoices - Receipts", "Text/Letter",
     "Text/Logs", "Text/Lower thirds list", "Text/Manuscript",
     "Text/Meeting notes", "Text/Newspaper article", "Text/Press clippings",
     "Text/Press kits", "Text/Press releases", "Text/Production notes",
     "Text/Promotional material", "Text/Proposals", "Text/Releases",
     "Text/Reports", "Text/Research material", "Text/Scripts",
     "Text/Transcript", "Text/Transcript - interview",
     "Text/Transcript - program"
    ]

    FORMAT_COLORS = [
     "B&W", "Grayscale", "Color", "B&W with grayscale sequences",
     "B&W with color sequences", "Grayscale with B&W sequences",
     "Grayscale with color sequences", "Color with B&W sequences",
     "Color with grayscale sequences", "Other"
    ]

    ESSENCE_TRACK_TYPES = ["video", "audio", "text", "caption", "subtitle",
        "metadata", "sprite", "timecode"]

    GENRES = [
      "Action", "Actuality", "Adults Only", "Adventure", "Advice",
      "Agriculture", "Animals", "Animation", "Anime", "Anthology", "Art",
      "Arts/crafts", "Auction", "Auto", "Aviation", "Awards", "Bicycle",
      "Biography", "Boat", "Business/Financial", "Call-in", "Children",
      "Children-music", "Children-special", "Children-talk", "Collectibles",
      "Comedy", "Comedy-drama", "Commentary", "Community", "Computers",
      "Concert", "Consumer", "Cooking", "Crime", "Crime drama", "Dance",
      "Debate", "Docudrama", "Documentary", "Drama", "Educational",
      "Entertainment", "Environment", "Event", "Excerpts", "Exercise",
      "Fantasy", "Fashion", "Feature", "Forecast", "French", "Fundraiser",
      "Game show", "Gay/lesbian", "Health", "Historical drama", "History",
      "Holiday", "Holiday music", "Holiday music special", "Holiday special",
      "Holiday-children", "Holiday-children special", "Home improvement",
      "Horror", "Horse", "House/garden", "How-to",
      "Interview", "Law", "Magazine", "Medical", "Miniseries", "Music",
      "Music special", "Music talk", "Musical", "Musical comedy", "Mystery",
      "Nature", "News", "News conference", "Newsmagazine", "Obituary",
      "Opera", "Outtakes", "Panel", "Parade", "Paranormal", "Parenting",
      "Performance", "Performing arts", "Political commercial", "Politics",
      "Polls and Surveys", "Press Release", "Promotional announcement",
      "Public service announcement", "Question and Answer Session", "Quote",
      "Reading", "Reality", "Religious", "Retrospective", "Romance",
      "Romance-comedy", "Science", "Science fiction", "Self improvement",
      "Shopping", "Sitcom", "Soap", "Soap special", "Soap talk", "Spanish",
      "Special", "Speech", "Sports", "Standup", "Suspense", "Talk",
      "Theater", "Trailer", "Travel", "Variety", "Voice-over", "War",
      "Weather", "Western"
    ]
  end

  # returns the LibXML::XML::Schema object of the PBCore schema
  def self.schema(pbcore_version)
    @@schemas ||= {}
    @@schemas[pbcore_version] ||= XML::Schema.document(XML::Document.file(File.join(File.dirname(__FILE__), "..", "data", PBCORE_VERSIONS[pbcore_version][:xsd])))
  end

  # creates a new PBCore validator object, parsing the provided XML.
  #
  # io_or_document can either be an IO object or a String containing an XML document.
  def initialize(io_or_document, pbcore_version = "1.2")
    XML.default_line_numbers = true
    @errors = []
    @pbcore_version = pbcore_version
    set_rxml_error do
      @xml = io_or_document.respond_to?(:read) ?
        XML::Document.io(io_or_document) :
        XML::Document.string(io_or_document)
    end
  end

  # checks the PBCore document against the XSD schema
  def checkschema
    return if @schema_checked || @xml.nil?

    @schema_checked = true
    set_rxml_error do
      @xml.validate_schema(Validator.schema(@pbcore_version))
    end
  end

  # check for things which are not errors, exactly, but which are not really good ideas either.
  #
  # this is subjective, of course.
  def checkbestpractices
    return if @practices_checked || @xml.nil?
    @practices_checked = true
    
    
    
    check_picklist('titleType', Picklists::TITLE_TYPES)
    check_lists('subject')
    check_picklist('descriptionType', Picklists::DESCRIPTION_TYPES)
    check_picklist('genre', Picklists::GENRES)
    check_picklist('relationType', Picklists::RELATION_TYPES)
    check_picklist('audienceLevel', Picklists::AUDIENCE_LEVELS)
    check_picklist('audienceRating', Picklists::AUDIENCE_RATINGS)
    check_picklist('creatorRole', Picklists::CREATOR_ROLES)
    check_picklist('contributorRole', Picklists::CONTRIBUTOR_ROLES)
    check_picklist('publisherRole', Picklists::PUBLISHER_ROLES)
    check_picklist('formatPhysical', Picklists::PHYSICAL_FORMATS)
    check_picklist('formatDigital', Picklists::DIGITAL_FORMATS)
    check_picklist('formatMediaType', Picklists::MEDIA_TYPES)
    check_picklist('instantiationMediaType', Picklists::INSTANTIATION_MEDIA_TYPES , 'You’re using a value for instantiationMediaType that is neither Moving Image nor Audio. While this is valid, we recommend using one of the standardized values from the controlled vocabulary for this element: http://pbcore.org/pbcore-controlled-vocabularies/instantiationmediatype-vocabulary/' )
    check_picklist('coverageType', Picklists::COVERAGE_TYPES , 'It looks like you’re using a value for coverageType that is neither Spatial nor Temporal. For valid PBCore, you must use one of the standardized values from the controlled vocabulary for this element: http://metadataregistry.org/concept/list/vocabulary_id/149.html' )
    check_picklist('formatGenerations', Picklists::GENERATIONS)
    check_picklist('formatColors', Picklists::FORMAT_COLORS)
    check_picklist('essenceTrackType', Picklists::ESSENCE_TRACK_TYPES)
    check_names('creator')
    check_names('contributor')
    check_names('publisher')
    check_only_one_format
    
    
    
    
    
    check_min_one_subelements('pbcoreCollection',['pbcoreDescriptionDocument'],"")
    ['pbcoreDescriptionDocument','pbcorePart'].each do |parentname| check_min_one_subelements(parentname,['pbcoreIdentifier','pbcoreTitle','pbcoreDescription'],"") ; end ;

    check_element_has_attribute('pbcoreIdentifier','source',"")
    
#     check_min_one_subelements('pbcoreRelation',['pbcoreRelationType','pbcoreRelationIdentifier'],"")
#     check_max_one_subelements('pbcoreRelation',['pbcoreRelationIdentifier','pbcoreRelationType'],"")
    ['pbcoreRelationType','pbcoreRelationIdentifier'].each do |subname| check_only_one_subelement('pbcoreRelation',subname.split(),"must contain two subelements and only one '#{subname}.'  Please repeat the entire 'pbcoreRelation' container element to express each relationship.") ; end ; 

    check_only_one_subelement('pbcoreCoverage',['coverage'],"should contain only one 'coverage' subelement.  Please repeat the entire pbcoreCoverage container element for each instance of coverage.")

    check_only_one_subelement('pbcoreCreator',['creator'],"should contain only one 'creator' subelement.  Please repeat the entire pbcoreCreator container element for each instance of creator.")    
    check_only_one_subelement('pbcoreContributor',['contributor'],"should contain only one 'contributor' subelement.  Please repeat the entire pbcoreContributor container element for each instance of contributor.")    
    check_only_one_subelement('pbcorePublisher',['publisher'],"should contain only one 'publisher' subelement.  Please repeat the entire pbcorePublisher container element for each instance of publisher.")        
    check_only_one_subelement('pbcoreRightsSummary',['rightsSummary', 'rightsLink','rightsEmbedded'],"should contain only one subelement.  Please repeat the entire pbcoreRightsSummary container element for each rightsSummary, rightsLink, or rightsEmbedded.")
    ['pbcoreInstantiationDocument','instantiationPart'].each do |parentname| check_min_one_subelements(parentname,['instantiationIdentifier','instantiationLocation'],"") ; end ;
    check_element_has_attribute('instantiationIdentifier','source',"")
    ['pbcoreInstantiationDocument','instantiationPart'].each do |parentname| check_max_one_subelements(parentname,['instantiationPhysical','instantiationDigital','instantiationStandard','instantiationLocation','instantiationMediaType','instantiationFileSize','instantiationTimeStart','instantiationDuration','instantiationDataRate','instantiationColors','instantiationTracks','instantiationChannelConfiguration','instantiationChannelConfiguration'],"") ; end ;

    check_only_one_subelement('instantiationRights',['rightsSummary', 'rightsLink','rightsEmbedded'],"should contain only one subelement.  Please repeat the entire instantiationRights container element for each rightsSummary, rightsLink, or rightsEmbedded.")

	['pbcoreExtension','instantiationExtension'].each do |parentname| check_only_one_subelement(parentname,['extensionWrap','extensionEmbedded'],"should contain only one subelement.  Please repeat the entire '#{parentname}' container element for each 'extensionWrap' or 'extensionEmbedded'") ; end ;
	['extensionElement','extensionValue'].each do |subname|  check_only_one_subelement('extensionWrap',subname.split(),"must contain one '#{subname}' subelement.") ; end ;
    
    
    check_valid_characters(['instantiationFileSize', 'instantiationDataRate', 'essenceTrackDataRate', 'essenceTrackFrameRate', 'essenceTrackPlaybackSpeed', 'essenceTrackSamplingRate', 'essenceTrackBitDepth', 'essenceTrackFrameSize', 'essenceTrackAspectRatio'],"g/[0-9]:x\///", msg = "For best practice, this technical element should only contain numeric values. To express a unit of measure for this element, we recommend using the @unitsOfMeasure attribute.")
    check_valid_characters(['instantiationTimeStart', 'instantiationDuration', 'essenceTrackTimeStart', 'essenceTrackDuration'],"g/[0-9]:\.//", msg = "This is valid, but we recommend using a timestamp format for this element, such as HH:MM:SS:FF or HH:MM:SS.mmm or S.mmm.")
    check_valid_length_codes(['instantiationLanguage', 'essenceTrackLanguage'], ';', "For valid PBCore, please use one of the ISO 639.2 or 639.3 standard language codes, which can be found at http://www.loc.gov/standards/iso639-2/ and http://www-01.sil.org/iso639-3/codes.asp. You can describe more than one language in the element by separating two three-letter codes with a semicolon, i.e. eng;fre.")
    
    # sort the error messages by line number 
    tmperrors=[]
    lastline=@xml.to_s.gsub(13.chr+10.chr,10.chr).tr(13.chr,10.chr).split(10.chr).count # figure out how to get the right number:  @xml.last.line_num isn't it 
    (1..lastline).reverse_each do |lnum|  @errors.select {|msg| msg.to_s.match(" line #{lnum.to_s} ") || msg.to_s.match(" at :#{lnum.to_s}" + 46.chr)}.each do |y| tmperrors<< y if not tmperrors.include?(y); end ; end
	# wacky that each item in tmperrors array is a 1-count array
    if @errors.to_s.include?(' element is not expected')
		tmperrors << ["===="]
		tmperrors << ["Error(s) below about 'expected' elements are about what appears out of the expected order:  missing (required) elements will be cited further; otherwise, consult PBCore documentation for proper sequencing."] 
	end

	# is it necessary to examine @errors for things *not* in tmperrors?  they would fail assumption of line# test
    @errors = tmperrors.reverse.reject {|x| x == []}.flatten
    
  end

  # returns true iff the document is perfectly okay
  def valid?
    checkschema
    checkbestpractices
    @errors.empty?
  end

  # returns true iff the document is at least some valid form of XML
  def valid_xml?
    !(@xml.nil?)
  end

  # returns a list of perceived errors with the document.
  def errors
    checkschema
    checkbestpractices
    @errors.clone
  end

  protected
  # Runs some code with our own LibXML error handler, which will record
  # any seen errors for later retrieval.
  #
  # If no block is given, then our error handler will be installed but the
  # caller is responsible for resetting things when done.
  def set_rxml_error
    XML::Error.set_handler{|err| self.rxml_error(err)}
    if block_given?
      begin
        yield
      rescue XML::Error
        # we don't have to do anything, because LibXML throws exceptions after
        # already passing them to the selected handler. kind of strange.
      end
      XML::Error.reset_handler
    end
  end

  def rxml_error(err) #:nodoc:
    @errors << err
  end

  private
  def check_picklist(elt, picklist, msg = "")
    each_elt(elt) do |node|
      if node.content.strip.empty?
        @errors << "#{elt} on #{node.line_num} is empty. Perhaps consider leaving that element out instead."
      elsif !picklist.any?{|i| i.downcase == node.content.downcase}
        @errors << "“#{node.content}” on line #{node.line_num} is not in the PBCore suggested picklist value for #{elt}.  " + msg.to_s 
      end
    end
    check_lists(elt)
  end

  def check_lists(elt)
    each_elt(elt) do |node|
      if node.content =~ /[,|;]/
        @errors << "In #{elt} on line #{node.line_num}, you have entered “#{node.content}”, which looks like it may be a list. It is preferred instead to repeat the containing element."
      end
    end
  end

  # look for "Mike Castleman" and remind the user to say "Castleman, Mike" instead.
  def check_names(elt)
    each_elt(elt) do |node|
      if node.content =~ /^(\w+\.?(\s\w+\.?)?)\s+(\w+)$/
        @errors << "It looks like the #{elt} “#{node.content}” on line #{node.line_num} might be a person's name. If it is, then it is preferred to have it like “#{$3}, #{$1}”."
      end
    end
  end

  # ensure that no single instantiation has both a formatDigital and a formatPhysical
  def check_only_one_format
    each_elt("pbcoreInstantiation") do |node|
      if node.find(".//pbcore:formatDigital", "pbcore:#{PBCORE_NAMESPACE}").size > 0 &&
          node.find(".//pbcore:formatPhysical", "pbcore:#{PBCORE_NAMESPACE}").size > 0
        @errors << "It looks like the instantiation on line #{node.line_num} contains both a formatDigital and a formatPhysical element. This is valid, but not recommended in PBCore XML."
      else 
      if node.find(".//pbcore:instantiationDigital", "pbcore:#{PBCORE_NAMESPACE}").size > 0 &&
          node.find(".//pbcore:instantiationPhysical", "pbcore:#{PBCORE_NAMESPACE}").size > 0
        @errors << "It looks like the instantiation on line #{node.line_num} contains both a instantiationDigital and a instantiationPhysical element. This is valid, but not recommended in PBCore XML."  
      end
      end
    end
  end
  
  def check_element_has_attribute(elementname,attributename,msg="")
       each_elt(elementname.to_s) do |node|
          isMissing=true
          node.attributes.each {|attribute| isMissing=false if attribute.name == attributename }
          # node.attributes.get_attribute(attributename)
          if isMissing
              @errors << "Element '#{elementname}' at line #{node.line_num} must contain the attribute '#{attributename}' " + msg.to_s
          end
       end
  end
  
  def check_only_one_subelement(parentname,subnames,msg = "")
#    subsum=0
    each_elt(parentname.to_s) do |node|
        subsum=0
    	subnames.each do |subname|
			subsum = subsum + node.find("./pbcore:#{subname}", "pbcore:#{PBCORE_NAMESPACE}").size 
		end
		if subsum != 1 
			@errors << "Element '#{parentname}' near line #{node.line_num} " + msg.to_s
		end
	end
  end
  
  def check_max_one_subelements(parentname,subnames,msg = "")
    each_elt(parentname.to_s) do |node| 
    	subnames.each do |subname|
			subsum = node.find("./pbcore:#{subname}", "pbcore:#{PBCORE_NAMESPACE}").size 
			if subsum > 1 
				@errors << "Element '#{subname}' near line #{node.line_num} isn’t repeatable. For valid PBCore, please find another way to incorporate that information.  " + msg.to_s
			end
		end
	end
  end
  
  def check_min_one_subelements(parentname,subnames,msg = "")
	each_elt(parentname.to_s) do |node| 
		subnames.each do |subname|
			subsum = node.find("./pbcore:#{subname}", "pbcore:#{PBCORE_NAMESPACE}").size 
			if subsum < 1 
				@errors << "Element '#{parentname}' near line #{node.line_num} is missing required subelement '#{subname}.'  For valid PBCore, please add a value for this element." + msg.to_s
			end
		end
	end 
  end

  def check_valid_characters(elements_array,validstring = "", msg = "")
    elements_array.each do |elt|
		each_elt(elt.to_s) do |node|
			if node.content.tr(validstring,"") != "" 
				@errors << "Element '#{node.name}' at line #{node.line_num} contains invalid #{node.content.tr(validstring,"").length} characters.  " + msg.to_s
			end
		end
	end
  end
  
  def check_valid_length_codes(elements_array, delimiter = ';' ,msg = "")
    elements_array.each do |elt|
		each_elt(elt.to_s) do |node|
			xcount=node.content.split(delimiter).select{|x| x.length < 2 || x.length > 3}.length
			if xcount != 0 
				@errors << "Element '#{node.name}' at line #{node.line_num} contains #{xcount} invalid value#{'s' if xcount > 1}.  " + msg.to_s
			end
		end
	end
  end


  def each_elt(elt)
    @xml.find("//pbcore:#{elt}", "pbcore:#{PBCORE_NAMESPACE}").each do |node|
      yield node
    end
  end
end
