"""小学コレ 10観点実機テスト（adb + PIL）。
使い方: python device_test_10.py kokugo sansu rika shakai
観点: 1起動 2Firebase 3UI 4操作 5通信 6クラッシュ 7性能 8バッテリー 9権限 10依存初期化
結果は T10_OUT に JSON と画面一覧画像(*_sheet.png)で出力する。目視確認を併用すること。
注意: gfxinfo は Flutter では参考値。バッテリーは短時間の温度/残量のみ。
"""
import subprocess, sys, time, re, os, json
from PIL import Image, ImageChops, ImageStat

ADB = os.environ.get("ADB", "adb")  # platform-tools の adb（PATH にあれば省略可）
OUT = os.environ.get("T10_OUT", os.path.join(os.path.dirname(os.path.abspath(__file__)), "t10_out"))
os.makedirs(OUT, exist_ok=True)

def adb(*a, timeout=120, binary=False):
    r = subprocess.run([ADB, *a], capture_output=True, timeout=timeout)
    return r.stdout if binary else r.stdout.decode("utf-8", "replace")

def shot(path):
    open(path, "wb").write(adb("exec-out", "screencap", "-p", binary=True))
    return Image.open(path).convert("RGB")

def tap(x, y):
    adb("shell", "input", "tap", str(x), str(y)); time.sleep(2.5)

def tap_text_if_present(labels):
    adb("shell", "uiautomator", "dump", "/sdcard/ui.xml")
    xml = adb("shell", "cat", "/sdcard/ui.xml")
    for lab in labels:
        m = re.search(r'(?:text|content-desc)="[^"]*' + re.escape(lab) + r'[^"]*"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"', xml)
        if m:
            x1, y1, x2, y2 = map(int, m.groups())
            tap((x1 + x2) // 2, (y1 + y2) // 2)
            return lab
    return None

def blank(img):
    st = ImageStat.Stat(img.crop((0, 240, img.width, img.height - 260)))
    return sum(st.stddev) / 3 < 8

def changed(a, b):
    d = ImageChops.difference(a, b).convert("L").point(lambda v: 255 if v > 24 else 0)
    return ImageStat.Stat(d).mean[0] / 255 * 100

def run(name, pkg, apk, navs, dismiss=("うけとる", "受け取る", "閉じる"), setup=None):
    R = {"app": name, "pkg": pkg}
    adb("install", "-r", apk, timeout=300)
    adb("shell", "am", "force-stop", pkg)
    adb("shell", "input", "keyevent", "KEYCODE_HOME"); time.sleep(1)
    adb("logcat", "-c")
    bat0 = adb("shell", "dumpsys", "battery")
    comp = adb("shell", "cmd", "package", "resolve-activity", "--brief", "-c", "android.intent.category.LAUNCHER", pkg).strip().splitlines()[-1].strip()
    out = adb("shell", "am", "start", "-W", "-n", comp)
    R["launch_status"] = (re.search(r"Status: (\w+)", out) or [None, "?"])[1]
    R["total_time_ms"] = int((re.search(r"TotalTime: (\d+)", out) or [0, -1])[1])
    time.sleep(10)
    adb("shell", "dumpsys", "gfxinfo", pkg, "reset")
    R["pid"] = adb("shell", "pidof", pkg).strip()
    focus = adb("shell", "dumpsys", "window").split("mCurrentFocus=")[1].split("\n")[0] if "mCurrentFocus=" in adb("shell", "dumpsys", "window") else ""
    R["focus_after_launch"] = focus.strip()[:120]
    for st in (setup or []):
        if st[0] == "tap": tap(st[1], st[2])
        elif st[0] == "text": adb("shell", "input", "text", st[1]); time.sleep(1)
        elif st[0] == "back": adb("shell", "input", "keyevent", "KEYCODE_BACK"); time.sleep(1.5)
    imgs = []
    p0 = os.path.join(OUT, f"{name}_0_home.png"); imgs.append(shot(p0))
    R["dismissed"] = tap_text_if_present(dismiss)
    if R["dismissed"]:
        p = os.path.join(OUT, f"{name}_0b_after_dialog.png"); imgs.append(shot(p))
    changes = []
    for i, nav in enumerate(navs, 1):
        before = imgs[-1]
        if nav == "BACK":
            adb("shell", "input", "keyevent", "KEYCODE_BACK"); time.sleep(2.5)
        else:
            tap(*nav)
        p = os.path.join(OUT, f"{name}_{i}.png"); im = shot(p); imgs.append(im)
        changes.append(round(changed(before, im), 1))
    R["nav_changes_pct"] = changes
    R["blank_screens"] = [i for i, im in enumerate(imgs) if blank(im)]
    R["focus_end"] = adb("shell", "dumpsys", "window").split("mCurrentFocus=")[1].split("\n")[0].strip()[:120]
    time.sleep(20)  # idle window for CPU/battery
    gfx = adb("shell", "dumpsys", "gfxinfo", pkg)
    m = re.search(r"Janky frames: (\d+) \(([\d.]+)%\)", gfx); R["janky"] = m.group(2) + "%" if m else "n/a"
    m = re.search(r"Total frames rendered: (\d+)", gfx); R["frames"] = int(m.group(1)) if m else 0
    mem = adb("shell", "dumpsys", "meminfo", pkg)
    m = re.search(r"TOTAL PSS:\s+(\d+)", mem) or re.search(r"TOTAL\s+(\d+)", mem)
    R["pss_mb"] = round(int(m.group(1)) / 1024) if m else -1
    cpu = adb("shell", "dumpsys", "cpuinfo")
    m = re.search(r"([\d.]+)% \d+/" + re.escape(pkg) + ":", cpu); R["cpu_idle_pct"] = float(m.group(1)) if m else 0.0
    bat1 = adb("shell", "dumpsys", "battery")
    g = lambda s, k: int((re.search(k + r": (\d+)", s) or [0, 0])[1])
    R["battery"] = {"level0": g(bat0, "level"), "level1": g(bat1, "level"), "temp_c": g(bat1, "temperature") / 10}
    pk = adb("shell", "dumpsys", "package", pkg)
    R["runtime_perms"] = sorted(set(re.findall(r"(android\.permission\.[A-Z_]+): granted=true", pk)))
    R["dialog_focus"] = "permissioncontroller" in R["focus_after_launch"] + R["focus_end"]
    pid = R["pid"].split()[0] if R["pid"].strip() else ""
    log = adb("logcat", "-d", *(["--pid=" + pid] if pid else []), timeout=120)
    full = adb("logcat", "-d", timeout=120)
    R["fatal"] = len(re.findall(r"FATAL EXCEPTION", log)); R["anr"] = len(re.findall(r"ANR in " + re.escape(pkg), full))
    R["firebase_ok"] = "FirebaseInitProvider: FirebaseApp initialization successful" in full and pkg in full or "FirebaseApp initialization successful" in log
    R["firebase_err"] = re.findall(r"(?i)(?:firebase|firestore)[^\n]{0,60}(?:error|exception|denied)[^\n]{0,60}", log)[:2]
    R["net_err"] = sorted(set(re.findall(r"UnknownHostException|SocketTimeoutException|PERMISSION_DENIED|Missing or insufficient|code=UNAVAILABLE", log)))
    R["dep_err"] = sorted(set(re.findall(r"WorkDatabase|Failed to create an instance|ClassNotFoundException|NoClassDefFoundError|MissingPluginException|InitializationProvider[^\n]{0,40}(?:fail|error)", log)))
    R["ads_present"] = bool(re.search(r"googlemobileads|MobileAds|admob", log, re.I))
    # contact sheet
    w, h = imgs[0].size; sc = 0.32; tw, th = int(w * sc), int(h * sc)
    n = len(imgs); sheet = Image.new("RGB", (tw * n, th), "white")
    for i, im in enumerate(imgs): sheet.paste(im.resize((tw, th)), (i * tw, 0))
    sheet.save(os.path.join(OUT, f"{name}_sheet.png"))
    json.dump(R, open(os.path.join(OUT, f"{name}.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print(json.dumps(R, ensure_ascii=False))

if __name__ == "__main__":
    APK = "H:/マイドライブ/apk/"
    tabs = [(324, 2160), (540, 2160), (756, 2160), (972, 2160), (108, 2160)]
    cfg = {
        "kokugo": ("com.yourwish.shougakukore.kokugo", APK + "kokugo-kore-app-release.apk", tabs + [(564, 180), "BACK"]),
        "sansu": ("com.yourwish.shougakukore.sansu", APK + "sansu-kore-app-release.apk", tabs),
        "rika": ("com.yourwish.shougakukore.rika", APK + "shokollen_science-app-release.apk", tabs),
        "shakai": ("com.yourwish.shougakukore.shakai2", APK + "social_quiz_app-app-release.apk",
                   [(540, 936), "BACK", (540, 1472), "BACK", (948, 180), "BACK", (660, 180), "BACK"]),
    }
    for a in sys.argv[1:]:
        pkg, apk, navs = cfg[a]
        setup = [("tap", 540, 1220), ("text", "hana"), ("back",), ("tap", 540, 2124)] if a == "rika" else None
        run(a, pkg, apk, navs, setup=setup)
