import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const KosGuardApp());

const ink = Color(0xFF182D28);
const forest = Color(0xFF24483C);
const leaf = Color(0xFF42765E);
const paper = Color(0xFFF7F5EF);
const muted = Color(0xFF7D8980);
const line = Color(0xFFE8E7DE);
const amber = Color(0xFFD9914B);

class KosGuardApp extends StatelessWidget {
  const KosGuardApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Kosguard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: paper,
          colorScheme: ColorScheme.fromSeed(seedColor: forest, surface: paper),
          fontFamily: 'Roboto',
        ),
        home: const HomeShell(),
      );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  String _facility = 'Semua';
  bool _isCapturingPhoto = false;
  String? _capturedPhotoPath;
  final List<KGItem> _items = List.of(demoItems);
  final List<ItemActivity> _activityEvents = List.of(demoActivityEvents);

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _myItems(),
      _activity(),
      _profile(),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _tab, children: pages)),
      bottomNavigationBar: _navigation(),
      floatingActionButton: _tab == 0 || _tab == 1
          ? FloatingActionButton.extended(
              onPressed: _addItem,
              backgroundColor: forest,
              foregroundColor: Colors.white,
              elevation: 1,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Daftarkan barang',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }

  Widget _home() {
    final activeItems = _items.where((i) => i.status == ItemStatus.active);
    final shown = _facility == 'Semua'
        ? activeItems.toList()
        : activeItems.where((i) => i.facility == _facility).toList();
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
          sliver: SliverToBoxAdapter(child: _topHeader()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 0),
          sliver: SliverToBoxAdapter(child: _greeting()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
          sliver: SliverToBoxAdapter(child: _overview()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 30, 22, 14),
          sliver: SliverToBoxAdapter(child: _inventoryHeader()),
        ),
        SliverToBoxAdapter(child: _filters()),
        if (shown.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _emptyInventory())
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 112),
            sliver: SliverList.separated(
              itemCount: shown.length,
              separatorBuilder: (_, __) => const SizedBox(height: 11),
              itemBuilder: (_, index) => _itemTile(shown[index]),
            ),
          ),
      ],
    );
  }

  Widget _topHeader() => Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: forest, borderRadius: BorderRadius.circular(13)),
            child: const Icon(Icons.home_work_rounded,
                color: Color(0xFFF3E9CF), size: 21),
          ),
          const SizedBox(width: 10),
          const Text('kosguard',
              style: TextStyle(
                  color: ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8)),
          const Spacer(),
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () => setState(() => _tab = 2),
            icon: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.notifications_none_rounded,
                  size: 25, color: ink),
              Positioned(
                  right: 0,
                  top: -1,
                  child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: amber, shape: BoxShape.circle))),
            ]),
          ),
          const SizedBox(width: 4),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE7E6D9),
            child: Text('A',
                style: TextStyle(
                    color: forest, fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ],
      );

  Widget _greeting() =>
      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.location_on_outlined, size: 15, color: leaf),
          SizedBox(width: 4),
          Text('KOST KEMUNING  ·  KAMAR 08',
              style: TextStyle(
                  fontSize: 10,
                  color: leaf,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.15)),
          Spacer(),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: muted),
        ]),
        SizedBox(height: 11),
        Text('Ruang bersama,\nlebih terjaga.',
            style: TextStyle(
                color: ink,
                fontSize: 31,
                height: 1.08,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.35)),
        SizedBox(height: 8),
        Text('Pratinjau dengan data contoh penghuni kost.',
            style: TextStyle(color: muted, fontSize: 13.5)),
      ]);

  Widget _overview() => Container(
        padding: const EdgeInsets.fromLTRB(19, 18, 18, 18),
        decoration: BoxDecoration(
            color: forest, borderRadius: BorderRadius.circular(21)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(
                child: Text('Sedang di ruang bersama',
                    style: TextStyle(
                        color: Color(0xFFF6F3E9),
                        fontSize: 15,
                        fontWeight: FontWeight.w600))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0xFF365C4D),
                  borderRadius: BorderRadius.circular(20)),
              child: const Row(children: [
                Icon(Icons.visibility_outlined,
                    size: 12, color: Color(0xFFD2E0D0)),
                SizedBox(width: 5),
                Text('Data contoh',
                    style: TextStyle(
                        color: Color(0xFFD2E0D0),
                        fontSize: 10,
                        fontWeight: FontWeight.w500))
              ]),
            ),
          ]),
          const SizedBox(height: 19),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${_items.where((i) => i.status == ItemStatus.active).length}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 41,
                    height: 0.98,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.8)),
            const Padding(
                padding: EdgeInsets.only(left: 9, bottom: 4),
                child: Text('barang aktif',
                    style: TextStyle(color: Color(0xFFD0DAD0), fontSize: 13))),
            const Spacer(),
            _facilityMini(Icons.local_laundry_service_rounded, 'Jemuran',
                '${_items.where((i) => i.facility == 'Jemuran').length}'),
            const SizedBox(width: 20),
            _facilityMini(Icons.kitchen_rounded, 'Kulkas',
                '${_items.where((i) => i.facility == 'Kulkas').length}'),
          ]),
        ]),
      );

  Widget _facilityMini(IconData icon, String label, String value) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 14, color: const Color(0xFFCAD9C8)),
          const SizedBox(width: 5),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700))
        ]),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Color(0xFFCAD9C8), fontSize: 10)),
      ]);

  Widget _inventoryHeader() =>
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Inventaris bersama',
              style: TextStyle(
                  color: ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5)),
          SizedBox(height: 4),
          Text('Terlihat oleh penghuni kost',
              style: TextStyle(color: muted, fontSize: 12)),
        ])),
        ElevatedButton.icon(
            onPressed: _reportItem,
            style: ElevatedButton.styleFrom(
                backgroundColor: amber,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: amber.withValues(alpha: 0.35),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: const Size(0, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            icon: const Icon(Icons.report_problem_rounded, size: 17),
            label: const Text('Laporkan',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
      ]);

  Widget _filters() => SizedBox(
        height: 39,
        child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            children: [
              for (final label in ['Semua', 'Jemuran', 'Kulkas'])
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _facility == label,
                      onSelected: (_) => setState(() => _facility = label),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                          color: _facility == label
                              ? Colors.white
                              : const Color(0xFF68756D),
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      backgroundColor: const Color(0xFFF0EFE8),
                      selectedColor: forest,
                      side: BorderSide(
                          color: _facility == label
                              ? forest
                              : const Color(0xFFE8E7DE)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                    )),
            ]),
      );

  Widget _itemTile(KGItem item) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => _showItem(item),
          child: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: const Color(0xFFECEBE4))),
            child: Row(children: [
              _itemArt(item),
              const SizedBox(width: 13),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Expanded(
                          child: Text(item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: ink,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700))),
                      const SizedBox(width: 6),
                      _status(item)
                    ]),
                    const SizedBox(height: 5),
                    Text('${item.category}  ·  Kamar ${item.room}',
                        style: const TextStyle(color: muted, fontSize: 11.5)),
                    const SizedBox(height: 9),
                    Row(children: [
                      Icon(
                          item.facility == 'Jemuran'
                              ? Icons.local_laundry_service_rounded
                              : Icons.kitchen_rounded,
                          size: 13,
                          color: leaf),
                      const SizedBox(width: 5),
                      Text(item.facility,
                          style: const TextStyle(
                              color: Color(0xFF52645A),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600)),
                      if (item.status == ItemStatus.active) ...[
                        const Spacer(),
                        Icon(Icons.schedule_rounded,
                            size: 12,
                            color:
                                item.remaining.contains('jam') ? amber : muted),
                        const SizedBox(width: 4),
                        Text(item.remaining,
                            style: TextStyle(
                                color: item.remaining.contains('jam')
                                    ? const Color(0xFFA86C2C)
                                    : muted,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500))
                      ]
                    ]),
                  ])),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded,
                  size: 19, color: Color(0xFFAEB5AD)),
            ]),
          ),
        ),
      );

  Widget _itemArt(KGItem item) => Container(
        width: 59,
        height: 64,
        decoration: BoxDecoration(
            color: item.artBg, borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: item.photoPath == null
            ? Stack(alignment: Alignment.center, children: [
                Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                            color: item.artColor.withValues(alpha: .10),
                            shape: BoxShape.circle))),
                Icon(item.icon, color: item.artColor, size: 29),
              ])
            : Image.file(File(item.photoPath!), fit: BoxFit.cover),
      );

  Widget _status(KGItem item) {
    final isActive = item.status == ItemStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEAF1E9) : const Color(0xFFECECE6),
          borderRadius: BorderRadius.circular(6)),
      child: Text(isActive ? 'Aktif' : 'Diambil',
          style: TextStyle(
              color: isActive ? leaf : muted,
              fontSize: 9.5,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _emptyInventory() => Padding(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 120),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                  color: Color(0xFFECEFE7), shape: BoxShape.circle),
              child: const Icon(Icons.inventory_2_outlined,
                  color: leaf, size: 24)),
          const SizedBox(height: 14),
          const Text('Belum ada barang di sini',
              style: TextStyle(
                  color: ink, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text(
              'Pilih fasilitas lain atau daftarkan barang saat menitipkannya.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 12, height: 1.45)),
        ]),
      );

  Widget _navigation() => NavigationBar(
        height: 68,
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: const Color(0xFFFCFBF8),
        indicatorColor: const Color(0xFFE7EDE4),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'Beranda'),
          NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_rounded),
              label: 'Barang saya'),
          NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Aktivitas'),
          NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil'),
        ],
      );

  Widget _myItems() {
    final myItems = _items.where((item) => item.isMine).toList();
    return _secondaryPage(
      title: 'Barang saya',
      subtitle: 'Pratinjau · data contoh penghuni kost.',
      child: myItems.isEmpty
          ? _emptyInventory()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 112),
              itemCount: myItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 11),
              itemBuilder: (_, i) => _itemTile(myItems[i]),
            ),
    );
  }

  Widget _activity() {
    final events = _activityEvents.toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return _secondaryPage(
      title: 'Aktivitas',
      subtitle: 'Riwayat status barang milikmu.',
      child: events.isEmpty
          ? _activityEmptyState()
          : ListView(
              padding: const EdgeInsets.fromLTRB(22, 2, 22, 40),
              children: [
                Row(children: [
                  const Expanded(
                    child: Text('LOG BARANG SAYA',
                        style: TextStyle(
                            color: muted,
                            fontSize: 10,
                            letterSpacing: .9,
                            fontWeight: FontWeight.w700)),
                  ),
                  if (events.every((event) => event.isSample)) _sampleLabel(),
                ]),
                const SizedBox(height: 16),
                for (var index = 0; index < events.length; index++)
                  _activityEntry(events[index],
                      isLast: index == events.length - 1),
              ],
            ),
    );
  }

  Widget _activityEmptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                    color: Color(0xFFECEFE7), shape: BoxShape.circle),
                child: const Icon(Icons.history_rounded, color: leaf, size: 24),
              ),
              const SizedBox(height: 14),
              const Text('Belum ada catatan aktivitas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ink, fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text(
                  'Daftarkan barang dan mulai sesi fasilitas untuk membuat riwayat status.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 12, height: 1.45)),
              const SizedBox(height: 17),
              FilledButton.icon(
                  onPressed: _addItem,
                  style: FilledButton.styleFrom(
                      backgroundColor: forest, foregroundColor: Colors.white),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Daftarkan barang')),
            ],
          ),
        ),
      );

  Widget _sampleLabel() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: const Color(0xFFECECE6),
            borderRadius: BorderRadius.circular(7)),
        child: const Text('DATA CONTOH',
            style: TextStyle(
                color: muted, fontSize: 9, fontWeight: FontWeight.w700)),
      );

  Widget _activityEntry(ItemActivity event, {required bool isLast}) =>
      IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: 34,
            child: Column(children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: Color(0xFFEAF1E9), shape: BoxShape.circle),
                child:
                    Icon(_activityIcon(event.newStatus), size: 15, color: leaf),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: const Color(0xFFDDE4D9)),
                ),
            ]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: line)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(_activityTitle(event.newStatus),
                                  style: const TextStyle(
                                      color: ink,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 8),
                            Text(_formatActivityTime(event.occurredAt),
                                style: const TextStyle(
                                    color: muted, fontSize: 9.5)),
                          ]),
                      const SizedBox(height: 4),
                      Text(event.itemName,
                          style: const TextStyle(
                              color: Color(0xFF56635A), fontSize: 11.5)),
                      const SizedBox(height: 9),
                      Row(children: [
                        _statusCode(event.oldStatus),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(Icons.arrow_forward_rounded,
                                size: 12, color: muted)),
                        _statusCode(event.newStatus),
                      ]),
                      const SizedBox(height: 9),
                      Row(children: [
                        Icon(
                            event.facility == 'Jemuran'
                                ? Icons.local_laundry_service_rounded
                                : Icons.kitchen_rounded,
                            size: 13,
                            color: leaf),
                        const SizedBox(width: 5),
                        Expanded(
                            child: Text(
                                '${event.facility} · Kamar ${event.room} · ${event.actor}',
                                style: const TextStyle(
                                    color: muted, fontSize: 10.5))),
                        if (event.isSample) _sampleLabel(),
                      ]),
                    ]),
              ),
            ),
          ),
        ]),
      );

  Widget _statusCode(String status) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFFF1F1EB),
            borderRadius: BorderRadius.circular(5)),
        child: Text(status,
            style: const TextStyle(
                color: Color(0xFF58665D),
                fontSize: 8.5,
                fontWeight: FontWeight.w700)),
      );

  IconData _activityIcon(String status) => switch (status) {
        'ACTIVE' => Icons.place_outlined,
        'RETRIEVED' => Icons.check_circle_outline_rounded,
        'EXPIRED' => Icons.schedule_rounded,
        'MISSING' => Icons.search_off_rounded,
        'FOUND' => Icons.inventory_2_outlined,
        'RETURNED' => Icons.assignment_return_outlined,
        _ => Icons.add_box_outlined,
      };

  String _activityTitle(String status) => switch (status) {
        'ACTIVE' => 'Sesi ruang bersama dimulai',
        'RETRIEVED' => 'Barang sudah diambil',
        'EXPIRED' => 'Sesi fasilitas berakhir',
        'MISSING' => 'Barang dilaporkan hilang',
        'FOUND' => 'Barang temuan dilaporkan',
        'RETURNED' => 'Barang dikembalikan',
        _ => 'Barang didaftarkan',
      };

  String _formatActivityTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    final clock =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inHours < 1) return '${difference.inMinutes} mnt lalu';
    if (difference.inDays == 0) return 'Hari ini · $clock';
    if (difference.inDays == 1) return 'Kemarin · $clock';
    return '${time.day}/${time.month}/${time.year} · $clock';
  }

  Widget _profile() => _secondaryPage(
        title: 'Profil',
        subtitle: 'Akun dan preferensi kost.',
        child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: line)),
                  child: const Row(children: [
                    CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFE7E6D9),
                        child: Text('A',
                            style: TextStyle(
                                color: forest, fontWeight: FontWeight.w700))),
                    SizedBox(width: 13),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Penghuni kost',
                              style: TextStyle(
                                  color: ink, fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('Kamar 08 · Kost Kemuning',
                              style: TextStyle(color: muted, fontSize: 12))
                        ]),
                    Spacer(),
                    Icon(Icons.chevron_right_rounded, color: muted)
                  ])),
              const SizedBox(height: 13),
              _profileRow(Icons.lock_outline_rounded, 'Privasi & visibilitas',
                  'Data pribadi tetap terlindungi'),
              _profileRow(Icons.qr_code_2_rounded, 'QR kamar',
                  'Akses inventaris kamar'),
              _profileRow(Icons.help_outline_rounded, 'Bantuan',
                  'Panduan penggunaan Kosguard'),
            ])),
      );

  Widget _profileRow(IconData icon, String title, String detail) => Container(
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: line)),
      child: Row(children: [
        Icon(icon, size: 19, color: leaf),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: ink, fontSize: 12.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(detail, style: const TextStyle(color: muted, fontSize: 10.5))
        ])),
        const Icon(Icons.chevron_right_rounded, size: 19, color: muted)
      ]));

  Widget _secondaryPage(
          {required String title,
          required String subtitle,
          required Widget child}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            color: ink,
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1)),
                    const SizedBox(height: 5),
                    Text(subtitle,
                        style: const TextStyle(color: muted, fontSize: 12.5))
                  ])),
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE7E6D9),
                      borderRadius: BorderRadius.circular(13)),
                  child: const Icon(Icons.home_work_rounded,
                      color: forest, size: 20)),
            ])),
        Expanded(child: child),
      ]);

  void _addItem() {
    final nameController = TextEditingController();
    String facility = 'Jemuran';
    _capturedPhotoPath = null;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: paper,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (sheetContext) => StatefulBuilder(
          builder: (context, setSheet) => Padding(
                padding: EdgeInsets.fromLTRB(
                    22, 12, 22, MediaQuery.of(context).viewInsets.bottom + 24),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Container(
                              width: 35,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFD6D6CE),
                                  borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(height: 22),
                      const Text('Daftarkan barang',
                          style: TextStyle(
                              color: ink,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -.6)),
                      const SizedBox(height: 5),
                      const Text('Mulai dari nama dan ruang bersama.',
                          style: TextStyle(color: muted, fontSize: 12.5)),
                      const SizedBox(height: 19),
                      _photoCapture(setSheet, sheetContext, _capturedPhotoPath),
                      const SizedBox(height: 18),
                      TextField(
                          controller: nameController,
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: 'Nama barang',
                              hintText: 'Contoh: Jaket denim',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(color: line)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(color: line)))),
                      const SizedBox(height: 16),
                      const Text('Ruang bersama',
                          style: TextStyle(
                              color: ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(children: [
                        for (final f in ['Jemuran', 'Kulkas'])
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      right: f == 'Jemuran' ? 8 : 0),
                                  child: ChoiceChip(
                                      label: Text(f),
                                      selected: facility == f,
                                      onSelected: (_) =>
                                          setSheet(() => facility = f),
                                      showCheckmark: false,
                                      labelStyle: TextStyle(
                                          color: facility == f
                                              ? Colors.white
                                              : muted,
                                          fontWeight: FontWeight.w600),
                                      backgroundColor: Colors.white,
                                      selectedColor: forest,
                                      side: BorderSide(
                                          color: facility == f ? forest : line),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8))))
                      ]),
                      const SizedBox(height: 22),
                      SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                              onPressed: () {
                                final name = nameController.text.trim();
                                if (name.isEmpty ||
                                    _capturedPhotoPath == null) {
                                  ScaffoldMessenger.of(sheetContext)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Tambahkan nama dan foto barang terlebih dahulu.')));
                                  return;
                                }
                                final createdAt = DateTime.now();
                                setState(() {
                                  _items.insert(
                                      0,
                                      KGItem(
                                          name: name,
                                          category: facility == 'Jemuran'
                                              ? 'Pakaian'
                                              : 'Makanan',
                                          facility: facility,
                                          room: '08',
                                          remaining: facility == 'Jemuran'
                                              ? '48 jam'
                                              : '7 hari',
                                          icon: facility == 'Jemuran'
                                              ? Icons.checkroom_rounded
                                              : Icons.lunch_dining_rounded,
                                          photoPath: _capturedPhotoPath,
                                          artBg: const Color(0xFFECE9DA),
                                          artColor: forest,
                                          isMine: true,
                                          status: ItemStatus.active));
                                  _activityEvents.insertAll(0, [
                                    ItemActivity(
                                      itemName: name,
                                      oldStatus: 'REGISTERED',
                                      newStatus: 'ACTIVE',
                                      occurredAt: createdAt,
                                      facility: facility,
                                      room: '08',
                                      actor: 'Kamu',
                                    ),
                                    ItemActivity(
                                      itemName: name,
                                      oldStatus: '—',
                                      newStatus: 'REGISTERED',
                                      occurredAt: createdAt
                                          .subtract(const Duration(seconds: 1)),
                                      facility: facility,
                                      room: '08',
                                      actor: 'Kamu',
                                    ),
                                  ]);
                                });
                                Navigator.pop(sheetContext);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '$name ditambahkan ke inventaris.'),
                                        behavior: SnackBarBehavior.floating));
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor: forest,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14))),
                              child: const Text('Simpan barang',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)))),
                    ]),
              )),
    ).whenComplete(nameController.dispose);
  }

  Widget _photoCapture(
    StateSetter setSheet,
    BuildContext sheetContext,
    String? photoPath,
  ) {
    return InkWell(
      onTap: _isCapturingPhoto
          ? null
          : () => _captureItemPhoto(setSheet, sheetContext),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 154,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFECEFE7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE4D9)),
        ),
        child: photoPath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: _isCapturingPhoto
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: forest),
                          )
                        : const Icon(Icons.camera_alt_outlined,
                            color: forest, size: 21),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      _isCapturingPhoto
                          ? 'Membuka kamera…'
                          : 'Ambil foto barang',
                      style: const TextStyle(
                          color: ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  const Text('Foto membantu mengenali barang di ruang bersama.',
                      style: TextStyle(color: muted, fontSize: 10.5)),
                ],
              )
            : Stack(fit: StackFit.expand, children: [
                Image.file(File(photoPath), fit: BoxFit.cover),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                    decoration: BoxDecoration(
                      color: forest,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.refresh_rounded,
                          size: 15, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Ambil ulang',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ]),
      ),
    );
  }

  Future<void> _captureItemPhoto(
      StateSetter setSheet, BuildContext sheetContext) async {
    setSheet(() => _isCapturingPhoto = true);
    try {
      final photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (!sheetContext.mounted || photo == null) return;
      setSheet(() => _capturedPhotoPath = photo.path);
    } catch (_) {
      if (!sheetContext.mounted) return;
      ScaffoldMessenger.of(sheetContext).showSnackBar(const SnackBar(
        content:
            Text('Kamera tidak dapat dibuka. Periksa izin kamera perangkat.'),
      ));
    } finally {
      if (sheetContext.mounted) {
        setSheet(() => _isCapturingPhoto = false);
      }
    }
  }

  void _showItem(KGItem item) => showModalBottomSheet<void>(
        context: context,
        backgroundColor: paper,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) => Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 32),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    _itemArt(item),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(item.name,
                              style: const TextStyle(
                                  color: ink,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 5),
                          Text('${item.category} · Kamar ${item.room}',
                              style:
                                  const TextStyle(color: muted, fontSize: 12))
                        ])),
                    _status(item)
                  ]),
                  const SizedBox(height: 18),
                  const Divider(color: line),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.place_outlined, size: 17, color: leaf),
                    const SizedBox(width: 9),
                    Text('Berada di ${item.facility}',
                        style: const TextStyle(
                            color: ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w600))
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Icon(
                        item.status == ItemStatus.active
                            ? Icons.schedule_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 17,
                        color: leaf),
                    const SizedBox(width: 9),
                    Text(
                        item.status == ItemStatus.active
                            ? 'Sisa sesi: ${item.remaining}'
                            : 'Sesi selesai karena barang sudah diambil',
                        style: const TextStyle(color: ink, fontSize: 12.5))
                  ]),
                  const SizedBox(height: 20),
                  if (item.status == ItemStatus.active && item.isMine)
                    SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                            onPressed: () {
                              final retrievedAt = DateTime.now();
                              setState(() {
                                item.status = ItemStatus.retrieved;
                                _activityEvents.insert(
                                    0,
                                    ItemActivity(
                                      itemName: item.name,
                                      oldStatus: 'ACTIVE',
                                      newStatus: 'RETRIEVED',
                                      occurredAt: retrievedAt,
                                      facility: item.facility,
                                      room: item.room,
                                      actor: 'Kamu',
                                    ));
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '${item.name} ditandai sudah diambil.'),
                                      behavior: SnackBarBehavior.floating));
                            },
                            style: FilledButton.styleFrom(
                                backgroundColor: forest,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13))),
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Tandai sudah diambil'))),
                ])),
      );

  void _reportItem() {
    String kind = 'Hilang';
    final detailsController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: paper,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (sheetContext) => StatefulBuilder(
          builder: (context, setSheet) => Padding(
                padding: EdgeInsets.fromLTRB(
                    22, 12, 22, MediaQuery.of(context).viewInsets.bottom + 24),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Container(
                              width: 35,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFD6D6CE),
                                  borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(height: 22),
                      const Text('Laporkan kejadian',
                          style: TextStyle(
                              color: ink,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -.6)),
                      const SizedBox(height: 5),
                      const Text(
                          'Ceritakan secara netral agar penghuni lain bisa membantu.',
                          style: TextStyle(color: muted, fontSize: 12.5)),
                      const SizedBox(height: 17),
                      Wrap(spacing: 8, children: [
                        for (final option in [
                          'Hilang',
                          'Tertukar',
                          'Barang temuan'
                        ])
                          ChoiceChip(
                              label: Text(option),
                              selected: kind == option,
                              onSelected: (_) => setSheet(() => kind = option),
                              showCheckmark: false,
                              labelStyle: TextStyle(
                                  color: kind == option ? Colors.white : muted,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11),
                              backgroundColor: Colors.white,
                              selectedColor: forest,
                              side: BorderSide(
                                  color: kind == option ? forest : line),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 7))
                      ]),
                      const SizedBox(height: 12),
                      TextField(
                          controller: detailsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                              labelText: 'Detail kejadian',
                              hintText: 'Barang terakhir terlihat di…',
                              alignLabelWithHint: true,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(color: line)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(color: line)))),
                      const SizedBox(height: 18),
                      SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                              onPressed: () {
                                if (detailsController.text.trim().isEmpty) {
                                  return;
                                }
                                Navigator.pop(sheetContext);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Laporan $kind dicatat dalam pratinjau.'),
                                        behavior: SnackBarBehavior.floating));
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor: forest,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14))),
                              child: const Text('Kirim laporan',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)))),
                    ]),
              )),
    ).whenComplete(detailsController.dispose);
  }
}

enum ItemStatus { active, retrieved }

class ItemActivity {
  const ItemActivity({
    required this.itemName,
    required this.oldStatus,
    required this.newStatus,
    required this.occurredAt,
    required this.facility,
    required this.room,
    required this.actor,
    this.isSample = false,
  });

  final String itemName;
  final String oldStatus;
  final String newStatus;
  final DateTime occurredAt;
  final String facility;
  final String room;
  final String actor;
  final bool isSample;
}

class KGItem {
  KGItem(
      {required this.name,
      required this.category,
      required this.facility,
      required this.room,
      required this.remaining,
      required this.icon,
      required this.artBg,
      required this.artColor,
      this.photoPath,
      this.isMine = false,
      required this.status});
  final String name;
  final String category;
  final String facility;
  final String room;
  final String remaining;
  final IconData icon;
  final Color artBg;
  final Color artColor;
  final String? photoPath;
  final bool isMine;
  ItemStatus status;
}

final _demoSessionStarted = DateTime.now().subtract(const Duration(hours: 27));

final demoActivityEvents = <ItemActivity>[
  ItemActivity(
    itemName: 'Kemeja linen',
    oldStatus: 'REGISTERED',
    newStatus: 'ACTIVE',
    occurredAt: _demoSessionStarted,
    facility: 'Jemuran',
    room: '08',
    actor: 'Kamu',
    isSample: true,
  ),
  ItemActivity(
    itemName: 'Kemeja linen',
    oldStatus: '—',
    newStatus: 'REGISTERED',
    occurredAt: _demoSessionStarted.subtract(const Duration(minutes: 3)),
    facility: 'Jemuran',
    room: '08',
    actor: 'Kamu',
    isSample: true,
  ),
];

final demoItems = <KGItem>[
  KGItem(
      name: 'Kemeja linen',
      category: 'Pakaian',
      facility: 'Jemuran',
      room: '08',
      remaining: '21 jam lagi',
      icon: Icons.checkroom_rounded,
      artBg: const Color(0xFFF0E8D8),
      artColor: const Color(0xFF9A7450),
      isMine: true,
      status: ItemStatus.active),
  KGItem(
      name: 'Sayur & telur',
      category: 'Bahan segar',
      facility: 'Kulkas',
      room: '03',
      remaining: '5 hari lagi',
      icon: Icons.egg_alt_rounded,
      artBg: const Color(0xFFE7EDD9),
      artColor: const Color(0xFF62784C),
      status: ItemStatus.active),
  KGItem(
      name: 'Handuk mandi',
      category: 'Kain & aksesori',
      facility: 'Jemuran',
      room: '11',
      remaining: '2 jam lagi',
      icon: Icons.dry_cleaning_rounded,
      artBg: const Color(0xFFE3EBEA),
      artColor: const Color(0xFF668486),
      status: ItemStatus.active),
  KGItem(
      name: 'Bekal makan siang',
      category: 'Makanan matang',
      facility: 'Kulkas',
      room: '06',
      remaining: '8 hari lagi',
      icon: Icons.lunch_dining_rounded,
      artBg: const Color(0xFFF2E5D7),
      artColor: const Color(0xFFAD7652),
      status: ItemStatus.active),
];
