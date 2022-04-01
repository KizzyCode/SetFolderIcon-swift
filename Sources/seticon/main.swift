import Foundation
import Cocoa


/// A SetFolderIcon related error
public enum SetIconError: Error {
    /// The CLI arguments are invalid
    case invalidArguments(String, StaticString = #file, Int = #line)
    /// An I/O-error occurred
    case inOutError(String, StaticString = #file, Int = #line)
}


/// A std-I/O text output stream
public struct Stdio: TextOutputStream {
    /// A stdout output stream
    static var stdout = Self(fileHandle: FileHandle.standardOutput)
    /// A stderr output stream
    static var stderr = Self(fileHandle: FileHandle.standardError)
    
    /// The file handle to write to
    private let fileHandle: FileHandle
    
    public func write(_ string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: true)!
        FileHandle.standardError.write(data)
    }
}


/// The helptext
public struct Help {
    /// The helptext
    public static let helptext =
        """
        Usage: seticon <icon> <folder>
        Arguments:
          icon    The path to the image file to set as folder icon
          folder  The folder to set the icon to
        """
}


/// The main function
public func main() throws {
    // Get the arguments
    guard CommandLine.arguments.count == 3 else {
        throw SetIconError.invalidArguments("Invalid amount of arguments")
    }
    let iconPath = CommandLine.arguments[1]
    let folderPath = CommandLine.arguments[2]
    
    // Read the icon and set it to the folder
    guard let icon = NSImage(contentsOfFile: iconPath) else {
        throw SetIconError.inOutError("Failed to open file: \(iconPath)")
    }
    guard NSWorkspace.shared.setIcon(icon, forFile: folderPath) else {
        throw SetIconError.inOutError("Failed to set icon to folder: \(folderPath)")
    }
}


// Entry point
do {
    // Run the main function
    try main()
} catch SetIconError.invalidArguments(let desc, _, _) {
    // Print the error and the help text
    print("Fatal error: \(desc)", to: &Stdio.stderr)
    print("", to: &Stdio.stderr)
    print(Help.helptext, to: &Stdio.stderr)
    Foundation.exit(1)
} catch SetIconError.inOutError(let desc, _, _) {
    // Print the error
    print("Fatal error: \(desc)", to: &Stdio.stderr)
    Foundation.exit(2)
}
