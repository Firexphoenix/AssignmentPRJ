document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("search-input");  // Lấy thanh tìm kiếm
    const movies = document.querySelectorAll(".movie-card");  // Lấy tất cả phim

    // Hàm debounce giúp tối ưu hiệu suất tìm kiếm
    function debounce(func, delay) {
        let timeout;
        return (...args) => {
            clearTimeout(timeout);
            timeout = setTimeout(() => func(...args), delay);
        };
    }

    // Hàm chuẩn hóa chuỗi tiếng Việt (loại bỏ dấu)
    function removeVietnameseTones(str) {
        str = str.normalize("NFD").replace(/[\u0300-\u036f]/g, ""); // Chuẩn hóa Unicode và bỏ dấu
        return str.replace(/đ/g, "d").replace(/Đ/g, "D"); // Xử lý riêng chữ "đ"
    }

    // Hàm lọc phim theo từ khóa (tìm cả theo Title và Genre)
    function filterMovies() {
        const query = searchInput.value.trim().toLowerCase();  // Lấy chuỗi tìm kiếm, chuyển về chữ thường
        const queryNoTones = removeVietnameseTones(query);  // Loại bỏ dấu tiếng Việt

        movies.forEach(movie => {
            const title = movie.getAttribute("data-title").toLowerCase().trim();  // Lấy tiêu đề phim
            const genre = movie.getAttribute("data-genre").toLowerCase().trim();  // Lấy thể loại phim

            const titleNoTones = removeVietnameseTones(title);  // Tiêu đề không dấu
            const genreNoTones = removeVietnameseTones(genre);  // Thể loại không dấu

            // Kiểm tra xem từ khóa có khớp với tiêu đề hoặc thể loại không
            const isMatch = title.includes(query) || titleNoTones.includes(queryNoTones) ||
                    genre.includes(query) || genreNoTones.includes(queryNoTones);

            movie.classList.toggle("hidden", !isMatch);  // Ẩn hoặc hiển thị phim theo kết quả tìm kiếm
        });
    }

    // Lắng nghe sự kiện nhập liệu
    searchInput.addEventListener("input", debounce(filterMovies, 300));
});
