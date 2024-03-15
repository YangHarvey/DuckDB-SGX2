import re
import csv
import sys

def format_queries(input_file, output_file):
    with open(input_file, 'r') as f:
        content = f.read()

    queries = re.findall(r'SELECT.*?;', content, re.DOTALL)
    formatted_data = []

    for i, query in enumerate(queries, start=1):
        cold_run = float(re.search(r'\d+\.\d+', content).group())
        content = content.replace(str(cold_run), '', 1)

        hot_run_1 = float(re.search(r'\d+\.\d+', content).group())
        content = content.replace(str(hot_run_1), '', 1)

        hot_run_2 = float(re.search(r'\d+\.\d+', content).group())
        content = content.replace(str(hot_run_2), '', 1)

        formatted_data.append([i, cold_run, hot_run_1, hot_run_2])

    with open(output_file, 'w', newline='') as csvfile:
        fieldnames = ['query_number', 'cold_run', 'hot_run_1', 'hot_run_2']
        writer = csv.writer(csvfile)
        writer.writerow(fieldnames)
        writer.writerows(formatted_data)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: format.py input output")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    format_queries(input_file, output_file)
