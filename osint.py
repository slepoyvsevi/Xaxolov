#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
OSINT TOOLKIT v55 — Complete Edition
ALL APIs + Deep AI Training + Smart Chaining + Auto Dorks + Full Investigation
"""
import re, json, time, hashlib, requests, threading, gzip, base64, os, sys
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
from urllib.parse import quote_plus

try:
    import colorama; colorama.init()
    R='\033[91m'; G='\033[92m'; Y='\033[93m'; B='\033[94m'; M='\033[95m'; C='\033[96m'; W='\033[97m'
    DIM='\033[2m'; BOLD='\033[1m'; BGR='\033[41m'; RESET='\033[0m'
except:
    R=G=Y=B=M=C=W=DIM=BOLD=BGR=RESET=''

HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0", "Accept": "application/json, text/html"}
BASE_DIR = Path(__file__).parent
RESULTS_DIR = BASE_DIR / "results"
RESULTS_DIR.mkdir(exist_ok=True)

# ==================== ALL API KEYS ====================
KEYS = {
    # Abstract API — 3 сервиса × 3 ключа
    "abstract_phone": ["734268d6ac8b4349b425a1b86ac5d330", "6bb4641b8fc34765b1d06c82b60dfc7e", "3a874a1f6849482faa9ce1b399afe284"],
    "abstract_email": ["9bc59e52bdc340acaed925ca99ce8154", "11d8e2af85ff4e838ac9ed53c446195c", "627f3cb7ff84462a9ca32bddd46a57d1"],
    "abstract_ip": ["a5bbbbeeb74e4108a078bd8b7184c65d", "eb8002d2be3c444ebe19fb33939df0e0", "98f39df3196348b29d578f3b40bc4069"],
    "dadata": "fae1241275555d94686eb7d65298822030300488",
    "dadata_secret": "dc96ccd97327d54e575be0a6000c532cce69446a",
    "ipqs": "alX837HdX30IzfpUYxI0cK8JlkRti38k",
    "disify": "FTo2ziByQUmjpy8kFm9o7VVRbPCsNNWBUlQs3x6O",
    "genderize": "85691786152fb66d006cfc742e2d93f5",
    "nationalize": "2d6f5fe000f7d0144b11e00d63af326a",
    "scamsearch": "m46wj8crzgixovbkp9ql7n5d3tsafy",
    "shodan": "xx6gSg9pWYmJcND1hEMbcWuOJtjbHSZ5",
    "enrich": "sk_live_dihgFylMPjPlOMGNRIfTPLAXIeJCkziUDvWZDVCsSINYyaRdKmdtyONZKPqmYRiv",
    "intelx": "82265027-d12b-426a-bdf3-ffd394da754b",
    "zoomeye": "a58E8736-C217-965B2-DF67-e18bb371a68",
    "datanewton": ["UqI2bySsB2ta", "d4UIsPcoHdLH"],
    "exa": "af23c9f2-444f-4620-ab79-93e6eb482de4",
    "fns": "b797de0bb8a9d321083607ff3f49d00e4fc6388d",
    "dehashed": "4yvbx5jBrxJf7a+b0ykGefeOo0wXwiq6D7Tc53MJPpUCgj+hx0dwjoI=",
    "gemini": "AIzaSyDNCQrP9JfhQF4ibXtRSTFnL3OOMLf4hy4",
    "telegram_bot": "8745544412:AAE95qZUo1J6P6GpYmfWGAXIwfHDyXy6SzQ",
}

# Headers
DADATA_H = {"Authorization": f"Token {KEYS['dadata']}", "Content-Type": "application/json", "X-Secret": KEYS["dadata_secret"]}
IPQS_H = {"IPQS-KEY": KEYS["ipqs"]}
INTELX_H = {"x-key": KEYS["intelx"]}
ZOOMEYE_H = {"API-KEY": KEYS["zoomeye"]}
ENRICH_H = {"Authorization": f"Bearer {KEYS['enrich']}"}
EXA_H = {"x-api-key": KEYS["exa"], "Content-Type": "application/json"}
DEHASHED_AUTH = base64.b64encode(f"api:{KEYS['dehashed']}".encode()).decode()
DEHASHED_H = {"Authorization": f"Basic {DEHASHED_AUTH}"}
FNS_H = {"Authorization": f"Bearer {KEYS['fns']}"}
GEMINI_URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key={KEYS['gemini']}"
TG_API = f"https://api.telegram.org/bot{KEYS['telegram_bot']}"

CACHE = {}
cache_lock = threading.Lock()

def http_get(url, headers=None, timeout=10):
    h = headers or HEADERS
    for i in range(2):
        try:
            r = requests.get(url, headers=h, timeout=timeout)
            if r.status_code == 429: time.sleep(2**i); continue
            return r
        except: time.sleep(0.5)
    return None

def http_post(url, data, headers=None, timeout=12):
    h = headers or {**HEADERS, "Content-Type": "application/json"}
    for i in range(2):
        try:
            r = requests.post(url, headers=h, json=data, timeout=timeout)
            if r.status_code == 429: time.sleep(2**i); continue
            return r
        except: time.sleep(0.5)
    return None

def clean_phone(p):
    d = re.sub(r'\D','',p)
    if len(d)==11 and d.startswith('8'): d='7'+d[1:]
    elif len(d)==10 and d.startswith('9'): d='7'+d
    return d

def format_phone(d):
    if len(d)==11: return f"+{d[0]} ({d[1:4]}) {d[4:7]}-{d[7:9]}-{d[9:11]}"
    return d

# ==================== GEMINI — MASTER OSINT TRAINED ====================
GEMINI_TRAINING = """You are the world's best OSINT investigator. You have solved ALL major cases:

TRAINING DATA (20+ real cases):
1. Bellingcat MH17: Instagram→VK→phone metadata→Google Earth geolocation
2. TraceLabs CTF: Instagram→email→Gravatar→GitHub→company website (4h find)
3. OCCRP Laundromat: Companies House→Cyprus registry→Panama Papers→$20B
4. GIJN War Crimes: TikTok→Telegram→VK→shadow analysis→satellite
5. Doxbin Method: phone→carrier→billing→property→relatives
6. FBI Cyber: IP→ISP→warrant, email→provider→recovery email
7. Bellingcat Syria: YouTube→frame analysis→Google Earth→coordinates
8. NYT Visual: social media→EXIF GPS→timeline→movement tracking
9. Forensic Architecture: 3D reconstruction→trajectory→weapon ID
10. Your cases: Discord→TikTok→Telegram→phone chain, bot→plugin system
11. Panama Papers: offshore→nominee→shell company→beneficial owner
12. Paradise Papers: trust→foundation→offshore→tax haven
13. FinCEN Files: SAR→bank→correspondent→money trail
14. Pegasus Project: phone number→NSO Group→spyware→target
15. Suisse Secrets: Credit Suisse→client→account→hidden wealth
16. BlueLeaks: police departments→emails→training→tactics
17. Oath Keepers: social media→membership→organization→Jan 6
18. COVID disinfo: fake accounts→bot networks→amplification→origin
19. Documenting Ukraine: war crimes→Bucha→satellite→before/after
20. Navalny poisoning: phone records→FSB agents→travel→novichok

YOU USE THESE TECHNIQUES:
- CHAINING: any identifier → ALL possible connections
- PIVOTING: every new data = new search
- CORRELATION: cross-reference timestamps, locations, usernames
- DORKING: Google Dorks for hidden data
- BREACH MINING: Dehashed, IntelX, BreachVIP, Psbdmp, Scylla, HIBP
- SOCIAL GRAPH: who follows whom, mutuals, shared groups
- GEO-LOCATION: EXIF, IP, image features, language patterns
- TIMELINE: chronological digital footprint
- MONEY TRAIL: companies, directors, addresses, offshore
- DARK WEB: Tor, marketplaces, forums, Telegram channels
- SANCTIONS: OFAC, UN, EU, UK sanctions lists
- DOMAIN RECON: WHOIS, DNS, subdomains, certificates

ALWAYS return valid JSON in Russian. Be thorough."""

def gemini_master_analyze(query, all_data):
    """Главный AI — обучен на 20+ кейсах"""
    prompt = f"""{GEMINI_TRAINING}

INVESTIGATE: {query}

ALL DATA:
{json.dumps(all_data, ensure_ascii=False)[:30000]}

Return JSON in Russian:
{{
  "профиль": {{"язык":"","национальность":"","локация":"","возраст":"","профессия":"","пол":""}},
  "цифровой_след": {{"соцсети":[],"email":[],"телефоны":[],"ники":[],"гео":[]}},
  "утечки": {{"количество":0,"источники":[],"критичность":"low/medium/high/critical"}},
  "техника": "какой метод использован",
  "связи": "как всё связано",
  "цепочка": ["шаг1","шаг2","..."],
  "риск": "low/medium/high/critical",
  "рекомендации": ["что искать"],
  "уверенность": 0-100
}}"""
    try:
        r = requests.post(GEMINI_URL,
            headers={"Content-Type":"application/json"},
            json={"contents":[{"parts":[{"text":prompt}]}],"generationConfig":{"temperature":0.1,"maxOutputTokens":1500}},
            timeout=25)
        if r.status_code == 200:
            text = r.json()["candidates"][0]["content"]["parts"][0]["text"].strip()
            text = text.replace("```json","").replace("```","").strip()
            return json.loads(text)
    except: pass
    return {"профиль":{},"уверенность":0,"рекомендации":["повторить"]}

# ==================== ALL API FUNCTIONS ====================
def abstract_phone(phone, ki=0):
    if ki>=len(KEYS["abstract_phone"]): return {}
    r = http_get(f"https://phonevalidation.abstractapi.com/v1/?api_key={KEYS['abstract_phone'][ki]}&phone={phone}")
    if r and r.status_code==429: return abstract_phone(phone,ki+1)
    return r.json() if r and r.status_code==200 else {}

def abstract_email(email, ki=0):
    if ki>=len(KEYS["abstract_email"]): return {}
    r = http_get(f"https://emailvalidation.abstractapi.com/v1/?api_key={KEYS['abstract_email'][ki]}&email={email}")
    if r and r.status_code==429: return abstract_email(email,ki+1)
    return r.json() if r and r.status_code==200 else {}

def abstract_ip(ip, ki=0):
    if ki>=len(KEYS["abstract_ip"]): return {}
    r = http_get(f"https://ipgeolocation.abstractapi.com/v1/?api_key={KEYS['abstract_ip'][ki]}&ip_address={ip}")
    if r and r.status_code==429: return abstract_ip(ip,ki+1)
    return r.json() if r and r.status_code==200 else {}

def ipqs_phone(phone):
    r = http_get(f"https://ipqualityscore.com/api/json/phone/{KEYS['ipqs']}/{phone}",IPQS_H)
    if r and r.status_code==200:
        d=r.json()
        if len(clean_phone(phone))==11 and d.get("line_type")=="Landline": d["line_type"]="Mobile"
        return d
    return {}

def ipqs_email(email):
    r = http_get(f"https://ipqualityscore.com/api/json/email/{KEYS['ipqs']}/{email}",IPQS_H)
    return r.json() if r and r.status_code==200 else {}

def ipqs_ip(ip):
    r = http_get(f"https://ipqualityscore.com/api/json/ip/{KEYS['ipqs']}/{ip}",IPQS_H)
    return r.json() if r and r.status_code==200 else {}

def dadata_phone(phone):
    r = http_post("https://cleaner.dadata.ru/api/v1/clean/phone",[phone],DADATA_H)
    return r.json() if r and r.status_code==200 else []

def dadata_fio(q):
    r = http_post("https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/fio",{"query":q},DADATA_H)
    return r.json().get("suggestions",[]) if r and r.status_code==200 else []

def dadata_address(q):
    r = http_post("https://cleaner.dadata.ru/api/v1/clean/address",[q],DADATA_H)
    return r.json() if r and r.status_code==200 else []

def dadata_bank(card):
    r = http_post("https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/bank",{"query":card},DADATA_H)
    return r.json().get("suggestions",[]) if r and r.status_code==200 else []

def dadata_company(inn):
    r = http_post("https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/party",{"query":inn},DADATA_H)
    return r.json().get("suggestions",[]) if r and r.status_code==200 else []

def disify(email):
    r = http_post("https://api.disify.com/v1/email",{"email":email})
    return r.json() if r and r.status_code==200 else {}

def genderize(name):
    r = http_get(f"https://api.genderize.io/?name={quote_plus(name)}&apikey={KEYS['genderize']}")
    return r.json() if r and r.status_code==200 else {}

def nationalize(name):
    r = http_get(f"https://api.nationalize.io/?name={quote_plus(name)}&apikey={KEYS['nationalize']}")
    return r.json() if r and r.status_code==200 else {}

def agify(name):
    r = http_get(f"https://api.agify.io/?name={quote_plus(name)}")
    return r.json() if r and r.status_code==200 else {}

def scamsearch(query):
    r = http_get(f"https://scamsearch.io/api/search?search={quote_plus(query)}&type=phone&api_token={KEYS['scamsearch']}",timeout=10)
    return r.json() if r and r.status_code==200 else {}

def mailcheck(email):
    r = http_get(f"https://api.mailcheck.ai/email/{email}")
    return r.json() if r and r.status_code==200 else {}

def enrich(email):
    r = http_get(f"https://api.enrich.so/v1/enrich?email={email}",ENRICH_H)
    return r.json() if r and r.status_code==200 else {}

def exa_search(q):
    r = http_post("https://api.exa.ai/search",{"query":q,"type":"auto","numResults":5},EXA_H)
    return r.json() if r and r.status_code==200 else {}

def shodan(ip):
    r = http_get(f"https://api.shodan.io/shodan/host/{ip}?key={KEYS['shodan']}")
    if r and r.status_code==200:
        d=r.json()
        return {"ip":d.get("ip_str"),"org":d.get("org"),"ports":d.get("ports",[]),"vulns":list(d.get("vulns",{}).keys()) if d.get("vulns") else [],"country":d.get("country_name"),"city":d.get("city")}
    return {}

def zoomeye(ip):
    r = http_get(f"https://api.zoomeye.org/host/search?query={ip}&page=1&pagesize=5",ZOOMEYE_H)
    return r.json() if r and r.status_code==200 else {}

def intelx(q):
    r = http_get(f"https://2.intelx.io/phonebook/search?q={quote_plus(q)}&limit=5",INTELX_H)
    if r and r.status_code==200:
        d=r.json(); recs=d.get("records",[])
        return {"found":True,"total":d.get("total",len(recs)),"records":recs[:5]} if recs else {"found":False}
    return {}

def breachvip(term,fields,wildcard=False):
    r = http_post("https://breach.vip/api/search",{"term":term,"fields":fields,"wildcard":wildcard,"case_sensitive":False})
    if r and r.status_code==200: return r.json().get("results",[])
    return []

def dehashed_search(query):
    r = http_get(f"https://api.dehashed.com/search?query={quote_plus(query)}&page=1&size=10",DEHASHED_H)
    if r and r.status_code==200: return r.json()
    return {}

def haveibeenpwned(email):
    r = http_get(f"https://haveibeenpwned.com/api/v3/breachedaccount/{email}",headers={"hibp-api-key":"","User-Agent":"OSINT"})
    if r and r.status_code==200: return [b["Name"] for b in r.json()]
    return []

def emailrep(email):
    r = http_get(f"https://emailrep.io/{email}")
    return r.json() if r and r.status_code==200 else {}

def psbdmp(query):
    r = http_get(f"https://psbdmp.ws/api/v3/search/{quote_plus(query)}")
    if r and r.status_code==200:
        d=r.json()
        return {"count":d.get("count",0),"results":d.get("data",[])[:5]}
    return {}

def scylla_search(query):
    r = http_get(f"https://scylla.so/api/v1/search?q={quote_plus(query)}&size=10")
    return r.json() if r and r.status_code==200 else {}

def leakcheck(email):
    r = http_get(f"https://leakcheck.io/api/public?check={email}",headers={"User-Agent":"Mozilla/5.0"})
    return r.json() if r and r.status_code==200 else {}

def gravatar(email):
    h = hashlib.md5(email.strip().lower().encode()).hexdigest()
    r = http_get(f"https://www.gravatar.com/{h}.json")
    return r.json() if r and r.status_code==200 else {}

def ipapi(ip):
    r = http_get(f"http://ip-api.com/json/{ip}?fields=66846719&lang=ru")
    return r.json() if r and r.status_code==200 else {}

def ipwhois(ip):
    r = http_get(f"https://ipwho.is/{ip}")
    return r.json() if r and r.status_code==200 else {}

def bgpview(ip):
    r = http_get(f"https://api.bgpview.io/ip/{ip}")
    return r.json() if r and r.status_code==200 else {}

def binlist(bin_prefix):
    r = http_get(f"https://lookup.binlist.net/{bin_prefix}",{"Accept":"application/json"})
    return r.json() if r and r.status_code==200 else {}

def datanewton_search(query, ki=0):
    if ki>=len(KEYS["datanewton"]): return {}
    r = http_post("https://api.datanewton.ru/v1/company/search",{"query":query},{"Authorization":f"Bearer {KEYS['datanewton'][ki]}","Content-Type":"application/json"})
    if r and r.status_code==429: return datanewton_search(query,ki+1)
    return r.json() if r and r.status_code==200 else {}

def fns_company(inn):
    r = http_get(f"https://api-fns.ru/api/egr?inn={inn}&key={KEYS['fns']}",FNS_H)
    if r and r.status_code==200:
        data=r.json()
        if data.get("items"): return data["items"][0]
    return {}

def github_api(username):
    r = http_get(f"https://api.github.com/users/{username}")
    if r and r.status_code==200:
        d=r.json()
        return {"login":d.get("login"),"name":d.get("name"),"bio":d.get("bio"),"company":d.get("company"),"location":d.get("location"),"email":d.get("email"),"twitter":d.get("twitter_username"),"repos":d.get("public_repos"),"followers":d.get("followers")}
    return {}

def gitlab_api(username):
    r = http_get(f"https://gitlab.com/api/v4/users?username={username}")
    if r and r.status_code==200:
        users=r.json()
        if users: return {"name":users[0].get("name"),"bio":users[0].get("bio"),"location":users[0].get("location")}
    return {}

def keybase_api(username):
    r = http_get(f"https://keybase.io/_/api/1.0/user/lookup.json?usernames={username}")
    if r and r.status_code==200:
        data=r.json()
        if data.get("them"): return {"name":data["them"][0].get("profile",{}).get("full_name",""),"bio":data["them"][0].get("profile",{}).get("bio",""),"location":data["them"][0].get("profile",{}).get("location","")}
    return {}

def api_interpol(name):
    r = http_get(f"https://ws-public.interpol.int/notices/v1/red?name={quote_plus(name)}")
    return r.json() if r and r.status_code==200 else {}

def api_crtsh(domain):
    domain = re.sub(r'^https?://','',domain).rstrip('/')
    r = http_get(f"https://crt.sh/?q=%25.{domain}&output=json")
    return r.json() if r and r.status_code==200 else []

def api_nominatim(address):
    r = http_get(f"https://nominatim.openstreetmap.org/search?q={quote_plus(address)}&format=json&limit=3",headers={"User-Agent":"OSINT/55"})
    time.sleep(1)
    return r.json() if r and r.status_code==200 else []

def whoisxml(domain):
    r = http_get(f"https://www.whois.com/whois/{domain}")
    if r and r.status_code==200:
        reg=re.search(r'Registrar:\s*([^\n]+)',r.text)
        cr=re.search(r'Creation Date:\s*([^\n]+)',r.text)
        result={}
        if reg: result["registrar"]=reg.group(1).strip()
        if cr: result["created"]=cr.group(1).strip()
        return result
    return {}

def alienvault_otx(ip):
    r = http_get(f"https://otx.alienvault.com/api/v1/indicators/IPv4/{ip}/general")
    return r.json() if r and r.status_code==200 else {}

def urlscan_search(domain):
    r = http_get(f"https://urlscan.io/api/v1/search/?q=domain:{domain}")
    return r.json() if r and r.status_code==200 else {}

def opensanctions(name):
    r = http_get(f"https://api.opensanctions.org/search/default?q={quote_plus(name)}&limit=5")
    return r.json() if r and r.status_code==200 else {}

def wikidata_search(query):
    r = http_get(f"https://www.wikidata.org/w/api.php?action=wbsearchentities&search={quote_plus(query)}&language=en&format=json")
    return r.json() if r and r.status_code==200 else {}

# Telegram APIs
def tg_me_check(username):
    r = http_get(f"https://t.me/{username}", timeout=5)
    if r and r.status_code == 200:
        text = r.text
        result = {"url": f"https://t.me/{username}", "exists": True}
        title = re.search(r'<meta property="og:title" content="([^"]+)"', text)
        desc = re.search(r'<meta property="og:description" content="([^"]+)"', text)
        if title: result["title"] = title.group(1)
        if desc: result["description"] = desc.group(1)[:300]
        return result
    return {"exists": False}

def tgstat_search(username):
    r = http_get(f"https://tgstat.com/channel/@{username}", timeout=6)
    if r and r.status_code == 200:
        result = {}
        subs = re.search(r'(\d+[\s\d]*)\s*подписчиков', r.text)
        ci = re.search(r'CI:\s*(\d+)', r.text)
        if subs: result["subscribers"] = subs.group(1).strip()
        if ci: result["citation_index"] = ci.group(1)
        return result if result else None
    return None

def telegago_search(username):
    r = http_get(f"https://telegago.com/search?q={quote_plus(username)}", timeout=8)
    if r and r.status_code == 200:
        results = re.findall(r'https://t\.me/([^"\s]+)', r.text)[:15]
        return list(set(results)) if results else None
    return None

def lyzem_search(username):
    r = http_get(f"https://lyzem.com/search?q={quote_plus(username)}", timeout=8)
    if r and r.status_code == 200:
        results = re.findall(r'https://t\.me/([^"\s]+)', r.text)[:15]
        return list(set(results)) if results else None
    return None

# Соцсети
SOCIALS = {
    "Telegram":"t.me","GitHub":"github.com","GitLab":"gitlab.com","Twitter":"x.com",
    "Instagram":"instagram.com","Reddit":"reddit.com/user","VK":"vk.com",
    "TikTok":"tiktok.com","YouTube":"youtube.com","Steam":"steamcommunity.com/id",
    "Twitch":"twitch.tv","Pinterest":"pinterest.com","Spotify":"open.spotify.com/user",
    "Patreon":"patreon.com","Linktree":"linktr.ee","CodePen":"codepen.io",
    "Facebook":"facebook.com","Discord":"discord.com/users","Medium":"medium.com/@",
    "Dev.to":"dev.to","Keybase":"keybase.io","Flickr":"flickr.com/people",
    "Vimeo":"vimeo.com","SoundCloud":"soundcloud.com","About.me":"about.me",
    "Behance":"behance.net","Dribbble":"dribbble.com","HackerNews":"news.ycombinator.com/user",
    "ProductHunt":"producthunt.com/@","Fiverr":"fiverr.com","Snapchat":"snapchat.com/add",
}

def search_social(nick, site, domain):
    r = http_get(f"https://{domain}/{quote_plus(nick)}",timeout=5)
    if r and r.status_code==200:
        text=r.text
        result={"site":site,"url":f"https://{domain}/{nick}","found":True,"data":{}}
        title=re.search(r'<meta[^>]*property="og:title"[^>]*content="([^"]+)"',text)
        desc=re.search(r'<meta[^>]*property="og:description"[^>]*content="([^"]+)"',text)
        if title: result["data"]["title"]=title.group(1)
        if desc: result["data"]["description"]=desc.group(1)
        return result
    return {"site":site,"found":False}

def google_dork(query, num=5):
    results=[]
    try:
        r = requests.get(f"https://search.sapti.me/search?q={quote_plus(query)}&format=json&limit={num}",timeout=8)
        if r.status_code==200:
            for item in r.json().get("results",[])[:num]:
                results.append({"title":item.get("title",""),"url":item.get("url",""),"text":item.get("content","")[:200]})
    except: pass
    return results

# ==================== SEARCH FUNCTIONS ====================
def search_phone(phone):
    d=clean_phone(phone)
    r={"query":phone,"type":"phone","validation":{"valid":len(d)>=10,"formatted":format_phone(d) if len(d)==11 else phone},"api":{}}
    if len(d)>=10:
        with ThreadPoolExecutor(max_workers=10) as ex:
            f={
                "abstract":ex.submit(abstract_phone,d),
                "ipqs":ex.submit(ipqs_phone,d),
                "dadata":ex.submit(dadata_phone,d),
                "scamsearch":ex.submit(scamsearch,d),
                "breachvip":ex.submit(breachvip,d,["phone"]),
                "intelx":ex.submit(intelx,d),
                "dehashed":ex.submit(dehashed_search,d),
                "psbdmp":ex.submit(psbdmp,d),
                "scylla":ex.submit(scylla_search,d),
            }
            for k,v in f.items():
                try: r["api"][k]=v.result()
                except: pass
    return r

def search_email(email):
    r={"query":email,"type":"email","api":{}}
    with ThreadPoolExecutor(max_workers=15) as ex:
        f={
            "abstract":ex.submit(abstract_email,email),
            "ipqs":ex.submit(ipqs_email,email),
            "disify":ex.submit(disify,email),
            "mailcheck":ex.submit(mailcheck,email),
            "enrich":ex.submit(enrich,email),
            "haveibeenpwned":ex.submit(haveibeenpwned,email),
            "emailrep":ex.submit(emailrep,email),
            "leakcheck":ex.submit(leakcheck,email),
            "breachvip":ex.submit(breachvip,email,["email"]),
            "gravatar":ex.submit(gravatar,email),
            "intelx":ex.submit(intelx,email),
            "dehashed":ex.submit(dehashed_search,email),
            "psbdmp":ex.submit(psbdmp,email),
            "scylla":ex.submit(scylla_search,email),
            "exa":ex.submit(exa_search,email),
        }
        for k,v in f.items():
            try:
                res=v.result()
                if isinstance(res,(dict,list)): r["api"][k]=res
            except: pass
    return r

def search_nick(nick):
    r={"query":nick,"type":"username","socials":[],"api":{},"deep_api":{},"telegram":{}}

    with ThreadPoolExecutor(max_workers=30) as ex:
        f={site:ex.submit(search_social,nick,site,domain) for site,domain in SOCIALS.items()}
        for _,fut in f.items():
            try:
                res=fut.result()
                if res and res.get("found"): r["socials"].append(res)
            except: pass
    r["socials"].sort(key=lambda x:x["site"])

    with ThreadPoolExecutor(max_workers=8) as ex:
        ft = {
            "tg_me": ex.submit(tg_me_check, nick),
            "tgstat": ex.submit(tgstat_search, nick),
            "telegago": ex.submit(telegago_search, nick),
            "lyzem": ex.submit(lyzem_search, nick),
        }
        for k,v in ft.items():
            try:
                res = v.result()
                if res: r["telegram"][k] = res
            except: pass

    with ThreadPoolExecutor(max_workers=5) as ex:
        fa={"github":ex.submit(github_api,nick),"gitlab":ex.submit(gitlab_api,nick),"keybase":ex.submit(keybase_api,nick)}
        for k,v in fa.items():
            try:
                res=v.result()
                if res: r["deep_api"][k]=res
            except: pass

    with ThreadPoolExecutor(max_workers=8) as ex:
        f={"breachvip":ex.submit(breachvip,nick,["username"]),"intelx":ex.submit(intelx,nick),"dehashed":ex.submit(dehashed_search,nick),"psbdmp":ex.submit(psbdmp,nick),"scylla":ex.submit(scylla_search,nick),"exa":ex.submit(exa_search,nick)}
        for k,v in f.items():
            try: r["api"][k]=v.result()
            except: pass

    return r

def search_ip(ip):
    r={"query":ip,"type":"ip","api":{}}
    with ThreadPoolExecutor(max_workers=12) as ex:
        f={
            "abstract":ex.submit(abstract_ip,ip),
            "ipapi":ex.submit(ipapi,ip),
            "ipwhois":ex.submit(ipwhois,ip),
            "ipqs":ex.submit(ipqs_ip,ip),
            "shodan":ex.submit(shodan,ip),
            "zoomeye":ex.submit(zoomeye,ip),
            "bgpview":ex.submit(bgpview,ip),
            "alienvault":ex.submit(alienvault_otx,ip),
            "breachvip":ex.submit(breachvip,ip,["ip"]),
            "intelx":ex.submit(intelx,ip),
            "dehashed":ex.submit(dehashed_search,ip),
        }
        for k,v in f.items():
            try:
                res=v.result()
                if isinstance(res,dict): r["api"][k]=res
            except: pass
    return r

def search_fio(fio):
    first=fio.split()[0] if ' ' in fio else fio
    r={"query":fio,"type":"fio","api":{}}
    with ThreadPoolExecutor(max_workers=10) as ex:
        f={
            "dadata":ex.submit(dadata_fio,fio),
            "genderize":ex.submit(genderize,first),
            "nationalize":ex.submit(nationalize,first),
            "agify":ex.submit(agify,first),
            "interpol":ex.submit(api_interpol,fio),
            "wikidata":ex.submit(wikidata_search,fio),
            "opensanctions":ex.submit(opensanctions,fio),
            "breachvip":ex.submit(breachvip,fio,["name"]),
            "dehashed":ex.submit(dehashed_search,fio),
            "exa":ex.submit(exa_search,fio),
        }
        for k,v in f.items():
            try: r["api"][k]=v.result()
            except: pass
    return r

def search_inn(inn):
    r={"query":inn,"type":"inn","api":{}}
    with ThreadPoolExecutor(max_workers=3) as ex:
        f={"dadata":ex.submit(dadata_company,inn),"fns":ex.submit(fns_company,inn),"datanewton":ex.submit(datanewton_search,inn)}
        for k,v in f.items():
            try: r["api"][k]=v.result()
            except: pass
    return r

def search_card(card):
    d=re.sub(r'\D','',card)
    prefix=d[:6] if len(d)>=6 else d[:4]
    return {"query":card,"type":"card","api":{"dadata":dadata_bank(card),"binlist":binlist(prefix)}}

def search_address(addr):
    return {"query":addr,"type":"address","api":{"dadata":dadata_address(addr),"nominatim":api_nominatim(addr)}}

def search_domain(domain):
    domain=re.sub(r'^https?://','',domain).rstrip('/')
    r={"query":domain,"type":"domain","api":{}}
    with ThreadPoolExecutor(max_workers=8) as ex:
        f={
            "breachvip":ex.submit(breachvip,domain,["domain"],True),
            "intelx":ex.submit(intelx,domain),
            "dehashed":ex.submit(dehashed_search,domain),
            "crtsh":ex.submit(api_crtsh,domain),
            "urlscan":ex.submit(urlscan_search,domain),
            "whois":ex.submit(whoisxml,domain),
            "exa":ex.submit(exa_search,domain),
        }
        for k,v in f.items():
            try: r["api"][k]=v.result()
            except: pass
    return r

# ==================== MASTER INVESTIGATION ====================
def master_investigation(q):
    print(f"\n{BGR}{W}{BOLD}  🕵️ MASTER INVESTIGATION v55  {RESET}")
    print(f"  {C}Цель:{RESET} {W}{q}{RESET}\n")

    # Определение типа
    if '@' in q: dtype = "email"
    elif re.match(r'^[\d\s\+\-\(\)]{7,18}$', q): dtype = "phone"
    elif re.match(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', q): dtype = "ip"
    elif re.match(r'^\d{10}$', q) or re.match(r'^\d{12}$', q): dtype = "inn"
    elif re.match(r'^\d{16}$', q): dtype = "card"
    elif re.match(r'^[a-zA-Z0-9_-]{3,30}$', q): dtype = "username"
    elif '.' in q and ' ' not in q: dtype = "domain"
    elif ',' in q or 'ул.' in q.lower(): dtype = "address"
    elif ' ' in q and len(q)>5: dtype = "fio"
    else: dtype = "search"

    print(f"  📋 Тип: {G}{dtype}{RESET}")

    # 1. Основной поиск
    print(f"\n  {Y}[1/4] Основной поиск...{RESET}")
    funcs = {"phone":search_phone,"email":search_email,"username":search_nick,"ip":search_ip,"fio":search_fio,"inn":search_inn,"card":search_card,"address":search_address,"domain":search_domain}
    result = funcs.get(dtype, search_nick)(q)

    # 2. Извлечение связей + умные дорки
    all_text = json.dumps(result, ensure_ascii=False)
    found_phones = list(set(re.sub(r'\D','',p) for p in re.findall(r'[\d\s\+\-\(\)]{10,18}', all_text) if len(re.sub(r'\D','',p))>=10))[:5]
    found_emails = list(set(re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', all_text)))[:5]
    found_nicks = list(set(re.findall(r'"site":\s*"([^"]+)".*?"url":\s*"[^"]+/([^"]+)"', all_text)))
    found_nicks = [n[1] for n in found_nicks if n[1]!=q][:5]

    # Авто-дорки
    print(f"  {Y}[2/4] Умные дорки + поиск связей...{RESET}")
    dorks = []
    if found_nicks:
        for nick in found_nicks[:3]:
            dorks.append(f'"{nick}" site:github.com')
            dorks.append(f'"{nick}" site:pastebin.com')
    if found_emails:
        for email in found_emails[:2]:
            dorks.append(f'"{email}"')
    dorks = list(set(dorks))[:8]

    dork_results = {}
    with ThreadPoolExecutor(max_workers=8) as ex:
        df = {dork: ex.submit(google_dork, dork, 3) for dork in dorks}
        for dork, fut in df.items():
            try:
                res = fut.result()
                if res: dork_results[dork] = res
            except: pass

    # Поиск по связям
    secondary = {}
    with ThreadPoolExecutor(max_workers=12) as ex:
        futures = {}
        for phone in found_phones[:2]:
            if phone != clean_phone(q): futures[f"phone_{phone}"] = ex.submit(search_phone, phone)
        for email in found_emails[:2]:
            if email != q: futures[f"email_{email}"] = ex.submit(search_email, email)
        for nick in found_nicks[:2]:
            futures[f"nick_{nick}"] = ex.submit(search_nick, nick)
        for k,v in futures.items():
            try: secondary[k] = v.result()
            except: pass

    # 3. AI анализ
    print(f"  {Y}[3/4] AI анализ (Gemini 3 Flash)...{RESET}")
    dossier = {
        "запрос": q,
        "тип": dtype,
        "основной": result,
        "связи": {"телефоны": found_phones, "email": found_emails, "ники": found_nicks},
        "дорки": {k: len(v) for k,v in dork_results.items()},
        "вторичный": {k: "найдено" for k in secondary}
    }
    ai = gemini_master_analyze(q, dossier)

    # 4. Сохранение
    print(f"  {Y}[4/4] Сохранение...{RESET}")
    dossier["ai_analysis"] = ai
    dossier["secondary"] = secondary
    dossier["dork_results"] = dork_results
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    fn = RESULTS_DIR / f"master_investigation_{ts}.json"
    fn.write_text(json.dumps(dossier, indent=2, ensure_ascii=False))

    # ==================== ВЫВОД ====================
    print(f"\n{G}{'═'*70}{RESET}")
    print(f"  {G}[✓] Досье: {fn.name}{RESET}")

    if ai and ai.get("уверенность",0) > 0:
        print(f"\n  {M}[🧠 AI АНАЛИЗ — {ai.get('уверенность',0)}%]{RESET}")
        if ai.get("техника"): print(f"  📚 Метод: {Y}{ai['техника']}{RESET}")

        profile = ai.get("профиль",{})
        if profile.get("язык"): print(f"  🗣️ {profile['язык']}")
        if profile.get("национальность"): print(f"  🌍 {profile['национальность']}")
        if profile.get("локация"): print(f"  📍 {profile['локация']}")
        if profile.get("профессия"): print(f"  💼 {profile['профессия']}")

        trail = ai.get("цифровой_след",{})
        if trail.get("соцсети"): print(f"\n  🌐 Соцсетей: {G}{len(trail['соцсети'])}{RESET}")
        if trail.get("телефоны"): print(f"  📱 Телефоны: {G}{', '.join(trail['телефоны'][:5])}{RESET}")
        if trail.get("email"): print(f"  📧 Email: {G}{', '.join(trail['email'][:5])}{RESET}")

        leaks = ai.get("утечки",{})
        if leaks.get("количество",0) > 0:
            print(f"\n  {R}💀 Утечки: {leaks['количество']} | {leaks.get('критичность','low')}{RESET}")

        if ai.get("связи"): print(f"\n  {C}🔗 Связи:{RESET} {ai['связи'][:250]}")
        if ai.get("цепочка"):
            print(f"\n  {Y}📋 Цепочка расследования:{RESET}")
            for step in ai["цепочка"]: print(f"    ▸ {step}")

        recs = ai.get("рекомендации",[])
        if recs:
            print(f"\n  {Y}🔍 Рекомендации:{RESET}")
            for r in recs[:5]: print(f"    ▸ {r}")

    # Основные находки
    print(f"\n  {B}[📊 НАЙДЕНО]{RESET}")
    if dtype == "phone":
        v = result.get("validation",{})
        if v.get("valid"): print(f"  📱 {G}{v.get('formatted',q)}{RESET}")
        dd = result.get("api",{}).get("dadata",[])
        if dd: print(f"  🏢 {dd[0].get('provider','?')} | {dd[0].get('region','?')}")
        ipqs = result.get("api",{}).get("ipqs",{})
        if ipqs.get("success"):
            print(f"  🛡 Fraud: {ipqs.get('fraud_score',0)}% | {ipqs.get('line_type','?')}")

    if dtype == "username" or found_nicks:
        soc = result.get("socials",[])
        if soc:
            print(f"  🌐 Соцсетей: {G}{len(soc)}{RESET}")
            for s in soc[:10]:
                data = s.get("data",{})
                name = data.get("name","") or data.get("title","")
                print(f"    ▸ {G}{s['site']}{RESET}: {DIM}{s['url']}{RESET}")
                if name: print(f"      {name}")

        deep = result.get("deep_api",{})
        gh = deep.get("github",{})
        if gh: print(f"  🐙 GitHub: {gh.get('name','')} | {gh.get('location','')} | 📦 {gh.get('repos',0)} repos")

    if found_emails: print(f"\n  📧 Email: {G}{', '.join(found_emails[:5])}{RESET}")
    if found_phones: print(f"  📱 Телефоны: {G}{', '.join(found_phones[:5])}{RESET}")

    # Утечки
    bv = result.get("api",{}).get("breachvip",[])
    dh = result.get("api",{}).get("dehashed",{})
    psb = result.get("api",{}).get("psbdmp",{})
    if bv: print(f"\n  {R}💀 BreachVIP: {len(bv)} утечек{RESET}")
    if dh.get("entries"): print(f"  {R}🔐 Dehashed: {len(dh['entries'])} записей{RESET}")
    if psb.get("count"): print(f"  {R}📄 Psbdmp: {psb['count']} паст{RESET}")

    # Дорки
    if dork_results:
        total = sum(len(v) for v in dork_results.values())
        print(f"\n  {Y}🔗 Дорки: {len(dork_results)} запросов, {total} результатов{RESET}")

    print(f"\n{DIM}{'═'*70}{RESET}")
    return dossier, fn

def search(q):
    q = q.strip()
    parts = q.split(maxsplit=1)
    cmd = parts[0].lower()
    query = parts[1] if len(parts) > 1 else ""

    if cmd in ['/investigate','/inv','/i'] and query: return master_investigation(query)
    elif cmd in ['/phone','/p'] and query: d = search_phone(query)
    elif cmd in ['/email','/e'] and query: d = search_email(query)
    elif cmd in ['/nick','/n'] and query: d = search_nick(query)
    elif cmd in ['/ip'] and query: d = search_ip(query)
    elif cmd in ['/fio','/f'] and query: d = search_fio(query)
    elif cmd in ['/inn'] and query: d = search_inn(query)
    elif cmd in ['/card','/c'] and query: d = search_card(query)
    elif cmd in ['/address','/addr'] and query: d = search_address(query)
    elif cmd in ['/domain','/dom'] and query: d = search_domain(query)
    elif cmd == '/leaks' and query:
        d = {"query":query,"type":"leaks","api":{"breachvip":breachvip(query,["email","phone","username"]),"dehashed":dehashed_search(query),"psbdmp":psbdmp(query)}}
    elif cmd == '/dorks' and query:
        dorks = [f'"{query}" site:github.com',f'"{query}" site:pastebin.com',f'"{query}" site:t.me']
        for dork in dorks:
            res = google_dork(dork)
            print(f"  {Y}{dork}{RESET}: {len(res)}")
            for r in res[:2]: print(f"    ▸ {r.get('url','')}")
        return None, None
    else:
        print(f"  {R}/investigate /phone /email /nick /ip /fio /inn /card /address /domain /leaks /dorks{RESET}")
        return None

    if isinstance(d, tuple): return d
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    fn = RESULTS_DIR / f"dossier_{ts}.json"
    fn.write_text(json.dumps({"query":q,"type":d.get("type","?"),"timestamp":datetime.now().isoformat(),"data":d}, indent=2, ensure_ascii=False))
    print(f"\n  {G}[✓] {fn.name}{RESET}")
    print_summary(d)
    return d, fn

def print_summary(d):
    """Краткий вывод для быстрых команд"""
    t = d.get("type","?")
    apis = d.get("api",{})
    print(f"\n{BGR}{W}{BOLD}  {d.get('query','?')}  {RESET}")
    if t=="phone":
        v=d.get("validation",{})
        if v.get("valid"): print(f"  {G}{v.get('formatted','?')}{RESET}")
        ipqs=apis.get("ipqs",{})
        if ipqs.get("success"): print(f"  IPQS: {ipqs.get('fraud_score',0)}% | {ipqs.get('carrier','?')}")
        dd=apis.get("dadata",[])
        if dd: print(f"  DaData: {dd[0].get('provider','?')}")
        bv=apis.get("breachvip",[])
        if bv: print(f"  {R}💀 BreachVIP: {len(bv)} утечек{RESET}")
    elif t=="email":
        hibp=apis.get("haveibeenpwned",[])
        if hibp: print(f"  HIBP: {len(hibp)} утечек")
        dh=apis.get("dehashed",{})
        if dh.get("entries"): print(f"  🔐 Dehashed: {len(dh['entries'])} записей")
    elif t=="username":
        soc=d.get("socials",[])
        if soc: print(f"  {G}🌐 Соцсетей: {len(soc)}{RESET}")
        for s in soc: print(f"    ▸ {s['site']}: {DIM}{s['url']}{RESET}")
        deep=d.get("deep_api",{})
        gh=deep.get("github",{})
        if gh: print(f"  GitHub: {gh.get('name','')} | 📦 {gh.get('repos',0)} repos")
    elif t=="ip":
        ipapi=apis.get("ipapi",{})
        if ipapi: print(f"  {ipapi.get('country','?')} | {ipapi.get('city','?')} | {ipapi.get('isp','?')}")
        sh=apis.get("shodan",{})
        if sh: print(f"  Shodan: {len(sh.get('ports',[]))} портов")
    elif t=="domain":
        crtsh=apis.get("crtsh",[])
        if crtsh: print(f"  🔐 CRT.sh: {len(crtsh)} сертификатов")
        ws=apis.get("whois",{})
        if ws: print(f"  🌐 WHOIS: {ws.get('registrar','?')}")
    print(f"{BOLD}{'─'*40}{RESET}")

def menu():
    print(f"""
{BGR}{W}{BOLD}╔══════════════════════════════════════════════════════════════╗{RESET}
{BGR}{W}{BOLD}║{RESET}   {BOLD}🕵️ OSINT TOOLKIT v55 | ALL APIs | AI Deep Training{RESET}       {BGR}{W}{BOLD}║{RESET}
{BGR}{W}{BOLD}╚══════════════════════════════════════════════════════════════╝{RESET}

{G}РАССЛЕДОВАНИЕ:{RESET}
  /investigate query   🧠 AI полное расследование (20+ кейсов обучение)

{G}ПОИСК:{RESET}
  /phone /email /nick /ip /fio /inn /card /address /domain

{Y}УТЕЧКИ / ДОРКИ:{RESET}
  /leaks query   💀 Поиск утечек
  /dorks query   🔗 Google Dorks

{Y}СИСТЕМА:{RESET}
  /results /help /quit""")

def main():
    try: colorama.init()
    except: pass
    menu()
    while True:
        try: cmd = input(f"\n{BOLD}{G}osint>{RESET} ").strip()
        except (EOFError, KeyboardInterrupt): print(f"\n{Y}Выход...{RESET}"); break
        if not cmd: continue
        if cmd.lower() in ['/quit','/exit','q']: break
        if cmd.lower() == '/help': menu(); continue
        if cmd.lower() == '/results':
            fs = sorted(RESULTS_DIR.glob("*investigation*.json") or RESULTS_DIR.glob("*dossier*.json"), reverse=True)[:10]
            if fs: [print(f"  {f.name}") for f in fs]
            else: print(f"  {DIM}Нет файлов{RESET}")
            continue
        search(cmd)

if __name__ == "__main__":
    try: main()
    except KeyboardInterrupt: print(f"\n{Y}Выход...{RESET}")