import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:karcisin_app/shared/app_theme.dart';
import 'package:karcisin_app/utils/date_helper.dart';
import '../../bloc/event/event_bloc.dart';
import '../../bloc/event/event_state.dart';
import '../../models/response/event_response.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedDate = 'Hari Ini';
  String _selectedCategory = 'Semua';

  final List<String> _dateFilters = ['Hari Ini', 'Besok', 'Akhir Pekan'];
  final List<String> _categoryFilters = [
    'Semua',
    'Musik',
    'Seni',
    'Teknologi',
    'Kuliner',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchField(),
            _buildFilters(),
            const SizedBox(height: 8),
            _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppTheme.accentRed,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Karcis.in',
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.accentRed, width: 1.5),
            ),
            child: const Icon(
              Icons.person,
              color: AppTheme.textPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        style: GoogleFonts.outfit(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'Cari event...',
          hintStyle: GoogleFonts.outfit(color: AppTheme.textMuted),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textMuted,
            size: 20,
          ),
          suffixIcon: _query.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  child: const Icon(
                    Icons.close,
                    color: AppTheme.textMuted,
                    size: 18,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppTheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            'TANGGAL',
            style: GoogleFonts.outfit(
              color: AppTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _dateFilters.length,
            itemBuilder: (_, i) {
              final label = _dateFilters[i];
              final selected = _selectedDate == label;
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.accentRed : AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.outfit(
                      color: selected ? Colors.white : AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KATEGORI',
                      style: GoogleFonts.outfit(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: AppTheme.surface,
                        style: GoogleFonts.outfit(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.textMuted,
                          size: 18,
                        ),
                        items: _categoryFilters
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: GoogleFonts.outfit(
                                    color: AppTheme.textPrimary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedCategory = v);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Expanded(
      child: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is! EventLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.accentRed),
            );
          }

          final filtered = state.events.where((e) {
            final matchQuery =
                _query.isEmpty ||
                e.title.toLowerCase().contains(_query.toLowerCase()) ||
                e.location.toLowerCase().contains(_query.toLowerCase());
            return matchQuery;
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filtered.length} Hasil',
                      style: GoogleFonts.outfit(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Hapus Filter',
                      style: GoogleFonts.outfit(
                        color: AppTheme.accentRed,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada event ditemukan',
                          style: GoogleFonts.outfit(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) =>
                            _SearchResultCard(event: filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final EventResponse event;
  const _SearchResultCard({required this.event});

  String get _categoryLabel {
    switch (event.categoryId) {
      case 1:
        return 'MUSIK';
      case 2:
        return 'SENI & BUDAYA';
      case 3:
        return 'WORKSHOP';
      case 4:
        return 'LIVE MUSIC';
      default:
        return 'EVENT';
    }
  }

  Color get _categoryColor {
    switch (event.categoryId) {
      case 1:
        return AppTheme.tagMusic;
      case 2:
        return AppTheme.tagArt;
      case 3:
        return AppTheme.tagWorkshop;
      case 4:
        return AppTheme.tagFood;
      default:
        return AppTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[900],
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: event.image,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.image, color: AppTheme.textMuted),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _categoryLabel,
                    style: GoogleFonts.outfit(
                      color: _categoryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    style: GoogleFonts.outfit(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppTheme.textMuted,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.startDate.toShortDate(),
                        style: GoogleFonts.outfit(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppTheme.textMuted,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: GoogleFonts.outfit(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
