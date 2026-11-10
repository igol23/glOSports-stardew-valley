# Stardew Valley — Türkçe Kurulum Rehberi

> Bu rehber, yayımlanacak HOME düzenindeki ZIP paketi için hazırlanmıştır. İlk test edilmiş Release yayımlandığında sürüm bilgileri ve uyumlu oyun yapısı bu sayfada kesinleştirilecektir.

## Gereksinimler

- goodluckOS yüklü, desteklenen bir GA36 ailesi el konsolu.
- Kendi yasal Stardew Valley kopyanız.
- Stardew Valley'in Steam **Compatibility** sürümü: **1.6.15.24356** (32-bit/XNA). Bu port özellikle Compatibility sürümünü hedefler; standart Steam kurulumundaki farklı sürüm dosyalarını kullanmayın.
- Yayımlanmış güncel HOME paketi.

## Kurulum

1. GitHub'daki [Releases](https://github.com/igol23/glOSports-stardew-valley/releases/latest) sayfasından en güncel ZIP paketini indirin.
2. ZIP içeriğini SD kartın **HOME** bölümünün köküne çıkarın ve mevcut klasörlerle birleştirin.
3. Paket, `.local/share/applications/stardew.puppy` menü kaydını Half-Life gibi goodluckOS Puppy uygulama dizinine yerleştirir. Çalışan bir `stardew.puppy` kaydınız varsa üzerine yazmayın; mevcut kaydı koruyun.
4. Steam'deki Stardew Valley **Compatibility 1.6.15.24356** (32-bit/XNA) sürümüne ait kendi oyun dosyalarınızı `HOME/ports/stardewvalley/gamedata/` klasörüne kopyalayın. `StardewValley.exe` ve `Content/` klasörü bu dizinin içinde bulunmalıdır. Farklı bir oyun sürümünün dosyaları çalışmayabilir.
5. Kartı güvenli şekilde çıkarıp cihaza takın ve goodluckOS'u yeniden başlatın. Puppy menü kayıtlarını açılışta okur.
6. Puppy başlatıcısında Games bölümünden **Stardew Valley** oyununu açın.

## Önemli

- Stardew Valley'in kendisi, ses dosyaları, oyun varlıkları ve kayıtları bu projede dağıtılmaz.
- `gamedata/` klasörüne yalnızca kendi oyun kopyanızdan aldığınız dosyaları yerleştirin.
- Menü simgesi, oyun dosyalarındaki başlık görselinden ilk çalıştırmada oluşturulur.
- Sorun giderme günlüğü: `HOME/logs/stardew.log`.
- Kayıt dosyalarınızı veya kişisel ayarlarınızı GitHub'a yüklemeyin.

## Sürüm seçimi

Eski dosyalar yerine her zaman [en güncel Releases paketini](https://github.com/igol23/glOSports-stardew-valley/releases/latest) kullanın. Henüz Release yayımlanmadan kaynak klasörünü doğrudan HOME bölümüne kopyalamayın.
