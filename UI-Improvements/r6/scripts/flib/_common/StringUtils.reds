
//module flib._common.StringUtils

public class StringUtils {

  public static func JoinStringArray(arr: array<String>, delim: String) -> String {
    let size = ArraySize(arr);
    let i = 0;
    let output: String = "";

    while i < size {
      if i > 0 {
        output += delim;
      }
      output += arr[i];

      i += 1;
    }

    return output;
  }

  public static func StrRepeat(str: String, rep: Int32) -> String {
    if rep <= 0 {
      return "";
    }
    let output = "";
    let i = 0;
    while i < rep {
      output += str;
      i += 1;
    }
    return output;
  }

  public static func LeftPad(str: String, width: Int32) -> String {
    if width <= 0 {
      return "";
    }

    if StrLen(str) >= width {
      return StrLeft(str, width);
    }

    while StrLen(str) < width {
      str = " " + str;
    }

    return str;
  }

  public static func RightPad(str: String, width: Int32) -> String {
    if width <= 0 {
      return "";
    }
    if StrLen(str) >= width {
      return StrLeft(str, width);
    }

    while StrLen(str) < width {
      str = str + " ";
    }

    return str;
  }

  /// Alternates left and right padding to center the string
  public static func CenterPad(str: String, width: Int32) -> String {
    if width <= 0 {
      return "";
    }
    if StrLen(str) >= width {
      return StrLeft(str, width);
    }
    let left: Bool = true;

    while StrLen(str) < width {
      str = left ? " " + str : str + " ";
      left = !left;
    }

    return str;
  }

  public static func Uint32ToHexStr(val: Uint32) -> String {
    let hexChars: array<String> = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
    let str: String = "";
    let i: Int32 = 0;

    while i < 8 {
      str = hexChars[Cast(val & 15u)] + str;
      val = val / 16u;

      i += 1;
    }

    return str;
  }
}
