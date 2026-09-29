#pragma once

#include <stdint.h>
#include <esp_system.h>

#ifdef __cplusplus

namespace fs {
class FS;
class File;
}

// The disabled Bluetooth section still gets scanned by some Arduino
// preprocessors, so make its callback type name available to generated
// declarations without enabling Bluetooth support.
typedef struct Frame Frame;
typedef void (*function_application_pointer) (char mode, char *io_buff);
typedef void (*function_action_pointer) (int action, char *filename);
typedef int (*function_conversion_pointer) (fs::File file, char *buff);
typedef double (*function_expr_value_by_name_pointer) (char *var_name);

void clearScreen();
void drawAppTitle(char *name);
char touchCheckNowait();
void image_from_bits(int start_x, int start_y, char *image, int color, int bg_color);
void touchWaitPress();
void touchExitActionReset();
void touchWaitRelease();
void touchWaitReleaseOrExit();
void drawButtonMatrix(int left_x, int top_y, int width, int height, char **str, int cols, int rows);
int touchCheckMatrix(int left_x, int top_y, int width, int height, char **str, int cols, int rows);
void view_text(char *title, char *data);
void cp_between_storages(fs::FS *Storage_from, char *path_from, fs::FS *Storage_to, char *path_to);
void cp_recursive_between_storages(fs::FS *Storage_from, char *path_from, fs::FS *Storage_to, char *path_to);
void delete_recursive(fs::FS *Storage_from, char *path);
char *http_get_error_text(int httpResponseCode, char *buff);
void basic_execute_command(char *str, char *cont_flag, fs::File *file);
int stream_get_line_by_index(fs::File file, int index, char *buff, int maxlen);
char *get_reset_reason_text(esp_reset_reason_t reason);
char *csv_get_next_field(char *str);
void *myOpen(const char *filename, int32_t *size);

#endif
