/*====================================
  �ߡߡ� PART 2. �׸��� & ���� �ߡߡ� 
 =====================================*/
// 2-6. �ð�
// ���� N�� �ԷµǸ� 00�� 00�� 00�ʺ��� N�� 59�� 59�ʱ����� ��� �ð� �߿��� 3�� �ϳ��� ���ԵǴ� 
//  ��� ����� ���� ���ϴ� ���α׷��� �ۼ���...

// �ð� ���� 15�� : 9�� 56�б���

// ���� �ۼ��� �ڵ�
import java.util.Scanner;

public class Study006
{
	public static void main(String[] args) 
	{
		Scanner sc = new Scanner(System.in);
		int n = sc.nextInt();	// �Է¹��� ���� N

		// �� �� ��.....
		int h = 0;
		int m = 0;
		int s = 0;
		int count = 0; // ����� ���� ���� count ����
		
		// ��� �ð� �߿��� 3�� �ϳ��� ���Եȴٸ�...
		// �ٵ� 3�� 2��, 3�� .. 5�� ��� ��ġ�� ��� ����?
		// �迭�ؼ� 1��~12��, 1��~60��, 1��~60�� �־ ã�ƺ����ϳ�,,,,???

		for (; ; )
		{
			if () // 3�� ���Եȴٸ�,,, �ٵ� ����?
			{
			}
		}

		
}

// ��� Ȯ��

import java.util.*;

public class Study006 {

    // Ư���� �ð� �ȿ� '3'�� ���ԵǾ� �ִ����� ����
    public static boolean check(int h, int m, int s) {
        if (h % 10 == 3 || m / 10 == 3 || m % 10 == 3 || s / 10 == 3 || s % 10 == 3)
            return true;
        return false;
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        // H�� �Է¹ޱ� 
        int h = sc.nextInt();
        int cnt = 0;

        for (int i = 0; i <= h; i++) {
            for (int j = 0; j < 60; j++) {
                for (int k = 0; k < 60; k++) {
                    // �� �ð� �ȿ� '3'�� ���ԵǾ� �ִٸ� ī��Ʈ ����
                    if (check(i, j, k)) cnt++;
                }
            }
        }

        System.out.println(cnt);
    }

