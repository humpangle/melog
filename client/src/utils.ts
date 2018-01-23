export interface ValidationError<ArrayError = {}> {
  [key: string]: string | { [key: string]: string } | ArrayError[];
}
