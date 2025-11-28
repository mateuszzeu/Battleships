Użyte narzędzia i agenci:
- Cursor
- Windsurf

Silniki:
- GPT-5.1 / GPT-5.1 Codex High
- Claude Sonnet 4.5
- Claude Opus 4.5
- Gemini 3 Pro
- Composer (w Cursorze)

#1. Rozpoczcie pracy: burza mózgów z GPT 5.1

Wrzucenie pliku wymagań projektu do chatu i rozpoczęcie rozmowy. Celem było wypracowanie planu działania oraz obranie architektury wraz z podziałem etapów.
Od razu wymusiłem, żeby zadawał pytania doprecyzowujące i nie generował kodu, dopóki nie ustalimy struktury.
Czy obeszło się bez problemów? oczywiście, że nie, po paru promptach GPT miał tendencję do generowania kodu, mimo że potrzebowałem samego planu. Musiałem to zatrzymać i doprecyzować, żeby skupił się wyłącznie na analizie i ustalaniu fundamentów projektu.

Prompt: Potrzebuję, żebyśmy najpierw ustalili strukturę i kolejność pracy. Nie generuj jeszcze żadnego kodu. Daj mi plan krok po kroku pod architekturę MVVM + SOLID i plan, w którym będziemy działać - krok po kroku. 

#2. Przejście na Cursor + Composer w celu przygotowania struktury w xcode.

Na tym etapie przesiadłem się z GPT na Cursora, bo GPT zaczynał wariować (prawdopodobnie przez zbyt dużą ilość kontektu - co dziwne bo poprzednie silniki bez problemu sobie z tym radziły). Musiałem co chwilę odświeżać okno, bo wisiał na odpowiedziach.

Poprosiłem GPT, żeby stworzył z naszej rozmowy jeden spójny prompt/podsumowanie, które mógłbym wkleić do Cursora.

Composer w Cursorze bardzo dobrze sprawdził się jako silnik do rozpoczęcia projektu, generował spokojniejsze, bardziej rozsądne etapy pracy.

#3. Budowanie logiki z Gemini 3 Pro.

Po ogarnięciu modeli i podstaw zacząłem kodowanie logiki aplikacji z Geminim 3 Pro.

#4. Weryfikacja i rozwijanie kodu z Claude Sonnet 4.5 + równoległa kontrola GPT 5.1
Najwięcej faktycznego kodowania i ulepszania robiłem wspólnie z Sonnetem 4.5.
Jednocześnie używałem GPT 5.1 jako mojego asystenta, gdy coś wyglądało dziwnie, zaznaczałem modelowi konkretną linię i weryfikowaliśmy to razem.
To działało bardzo dobrze, GPT szybko wskazywał błędy Sonneta, a Sonnet się z nimi zgadzał (nawet gdy poprosiłem, żeby podchodził krytycznie).

#5. Przesiadka na Opus 4.5
Z racji tego, że GPT bardzo często poprawiał Sonneta postanowiłem przejść na Opus 4.5.
Opus 4.5 robił najmniej błędów, odpowiedzi były najstabilniejsze i praktycznie nie wymagał już drugiej weryfikacji (GPT równiez potwierdzial zamiast proponowac lepsze rozwiazania jak wczesniej).

#6. Review kodu z GPT 5.1 Codex High
Gdy miałem już MVP, otworzyłem nowy chat z GPT 5.1 Codex High i poprosiłem go o pełną weryfikację każdego pliku, sprawdzenie zgodności z wymaganiami zadania, znalezienie elementów do uproszczenia lub wyrzucenia.

Na tym etapie straciłem dostęp do Cursora (w toerii planowo ale niespodziewanie - chcac wczesniej przesiąść się na Windsurfa, nie było sensu wykupywać kolejnego miesiąca na dokończenie, więc dokończyłem recenzję w Windsurfie).

#7 Ostateczna weryfikacja via Windsurf
Windsurf okazał się bardzo fajny (póki co), ma pare modeli, które w ogóle nie używają tokenów, jest również tańszy od windsurfa o 1/4 ceny. Interfejs trochę gorszy niż Cursora (może kwestia przyzwyczajenia) - poza tym praktycznie to samo. 

#8 Trudności i obserwacje podczas pracy
Największy problem były sprzeczne odpowiedzi dotyczace @MainActor w testach. Przy oznaczaniu testów @MainActor każdy model miał inną opinię. To mnie najbardziej spowolniło, szczególnie Sonnet i Opus ciągle sobie zaprzeczały. (relatywnie niedawno zacząłem pracować z nowym macro w swiftcie).
W końcu porównałem to z oficjalną dokumentacją Apple, a dodatkowo wrzuciłem pytanie do GPT z deep research:

„Na podstawie dokumentacji Apple i informacji w internecie - czy dodanie @MainActor do final class BoardServiceTests: XCTestCase jest poprawnym podejściem? Chodzi o pozbycie się komunikatu:
"Main actor-isolated conformance of Position to Hashable cannot be used in nonisolated context (Swift 6 language mode)".
Uzasadnij odpowiedz.”

Dopiero po takim dokładnym porównaniu udało się dojść do poprawnego rozwiązania.

AI często pomijało importy lub próbowało używać starych rozwiązań typu DispatchQueue zamiast async/await.

Warto zauważyć, że w całości korzystałem tylko z "ASK" mode, nie lubię oddawać pełnej kontroli bo AI nie jest jeszcze na tak dobrym poziomie (jak coś pójdzie nie tak dużo jest po tym sprzątania oraz potrafią generować pliki, których Xcode nie chciał pokazywać - widziałem je dopiero robiąc commity) -> btw. w tym teamcie bardzo nie polecam pracy z Codexem (może to naprawili ale jak tylko pojawił się w polsce używałem go przez pare dni i mocno napsuł on xcoda podowując u niego wyśietalnie błędów w kodzie, które nie istniały - postawienie systemu na nowo dopiero rozwiązało problem). 

Najczęstszy prompt którego uzywałem "Ta linia wygląda nielogicznie. Wyjaśnij, czy w kontekście reszty pliku jest to poprawne. Jeśli nie, podaj mi najprostsze poprawne rozwiązanie, ale bez rozpisywania całego pliku." wrzucając częśco screenshota lub wklejony kod.

#9 Ogólne wnioski 
AI działa najlepiej, gdy ma jasno postawione ramy: architektura, styl, zasada pracy etapami, brak generowania dużych plików naraz.
Bez tego próbuje stworzyc wszystko naraz, co prowadzi do błędów i chaosu. 

W moim przypadku AI realnie przyspieszyło pracę, szczególnie przy logice gry, ale nadal wymaga nadzoru, bo niektóre elementy (macro, async/await, struktura testów, Swift 6 warnings) potrafi interpretować błędnie.
